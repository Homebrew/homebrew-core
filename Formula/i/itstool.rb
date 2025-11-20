class Itstool < Formula
  desc "Make XML documents translatable through PO files"
  homepage "https://itstool.org/"
  url "https://files.itstool.org/itstool/itstool-2.0.7.tar.bz2"
  sha256 "6b9a7cd29a12bb95598f5750e8763cee78836a1a207f85b74d8b3275b27e87ca"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url "https://itstool.org/download.html"
    regex(/href=.*?itstool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "716cb0efd44428ef62000438ff166627c117befbdd87b6d9c5580afac54c9dc2"
    sha256 cellar: :any,                 arm64_sequoia: "8659b398ae66d88d974879a6a4e4372f21b81f7d018b13d9dd10b459e84ddd95"
    sha256 cellar: :any,                 arm64_sonoma:  "d632addd4bb1f3f422347e9f78d49d5e50d15b7a2479ff197b228082b08c32f2"
    sha256 cellar: :any,                 sonoma:        "9304cac2b3d4b0ce0cc09134157dcd281536f5ece469dda5f2bff14fbb16c126"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6482a8c862c867c1c53bd78c2128c9997d67a0905c700ba05eebbc0417742d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8847008ec88f06667281b8517d4a934cf68757cb3b835d2c00a0fe356190f02a"
  end

  head do
    url "https://github.com/itstool/itstool.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "doxygen" => :build # for libxml2 python bindings
  depends_on "pkgconf" => :build # for libxml2 python bindings
  depends_on "python-setuptools" => :build # for libxml2 python bindings
  depends_on "libxml2"
  depends_on "python@3.14"

  # Need deprecated libxml2 python bindings. May switch to lxml in future:
  # Ref: https://github.com/itstool/itstool/pull/57
  resource "libxml2" do
    url "https://download.gnome.org/sources/libxml2/2.15/libxml2-2.15.1.tar.xz"
    sha256 "c008bac08fd5c7b4a87f7b8a71f283fa581d80d80ff8d2efd3b26224c39bc54c"
  end

  def python3
    "python3.14"
  end

  def install
    resource("libxml2").stage do
      # We need to insert our include dir first
      includes = [Formula["libxml2"].opt_include]
      includes << (OS.mac? ? "#{MacOS.sdk_for_formula(self).path}/usr/include" : HOMEBREW_PREFIX/"include")
      inreplace "python/setup.py.in", "includes_dir = [",
                                      "includes_dir = [#{includes.map { |inc| "'#{inc}'," }.join(" ")}"

      # Run configure to generate setup.py and Doxygen XML
      system "./configure", "--disable-silent-rules",
                            "--with-history",
                            "--with-http",
                            "--with-icu",
                            "--with-legacy", # https://gitlab.gnome.org/GNOME/libxml2/-/issues/751#note_2157870
                            "--with-python",
                            *std_configure_args(prefix: libexec)
      system "make", "-C", "doc", "html.stamp"

      # Needed for Python 3.12+.
      # https://github.com/Homebrew/homebrew-core/pull/154551#issuecomment-1820102786
      with_env(PYTHONPATH: Pathname.pwd/"python") do
        system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec), "./python"
      end
      ENV.append_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)
    end

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--prefix=#{libexec}", "PYTHON=#{which(python3)}"
    system "make", "install"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"]
    pkgshare.install_symlink libexec/"share/itstool/its"
    man1.install_symlink libexec/"share/man/man1/itstool.1"

    # Check for itstool data files in HOMEBREW_PREFIX. This also ensures uniform bottles.
    inreplace libexec/"bin/itstool" do |s|
      s.sub! "'.local', 'share'", "'.local', 'share', 'itstool'"
      s.sub! "/usr/local/share", "#{HOMEBREW_PREFIX}/share/itstool"
      s.sub! "/usr/share", "/usr/share/itstool"
      s.sub! "ddir, 'itstool', 'its'", "ddir, 'its'"
    end
  end

  test do
    (testpath/"test.xml").write <<~XML
      <tag>Homebrew</tag>
    XML
    system bin/"itstool", "-o", "test.pot", "test.xml"
    assert_match "msgid \"Homebrew\"", File.read("test.pot")
  end
end
