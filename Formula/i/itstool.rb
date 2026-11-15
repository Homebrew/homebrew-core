class Itstool < Formula
  desc "Make XML documents translatable through PO files"
  homepage "https://itstool.org/"
  url "https://files.itstool.org/itstool/itstool-2.0.7.tar.bz2"
  sha256 "6b9a7cd29a12bb95598f5750e8763cee78836a1a207f85b74d8b3275b27e87ca"
  license "GPL-3.0-or-later"
  revision 3
  compatibility_version 1

  livecheck do
    url "https://itstool.org/download.html"
    regex(/href=.*?itstool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a31dcf345f29a0fd0fcfc1d6cf0c34bc7e7482f87349f458acdd8c54b0dfcc85"
    sha256 cellar: :any, arm64_tahoe:       "798b7493e61251f654eeef9e0d2b83be3a320e2e61c4d812315a8c9febb57d5d"
    sha256 cellar: :any, arm64_sequoia:     "88fb9fd3d60d99ccfef02dafc07ec1dab2fd420c5b9a0e1720f9cfecb357ce3e"
    sha256 cellar: :any, arm64_linux:       "87b1be0ca0cf01f2aecc766040c560754fd0c217e49c23210c55f6fa48fcd4e1"
    sha256 cellar: :any, x86_64_linux:      "1997de57a1e67740115325154dc6b3e06e878a2f4397dea354dbd531c6a93bf5"
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
  depends_on "python@3.15"

  # Need deprecated libxml2 python bindings. May switch to lxml in future:
  # Ref: https://github.com/itstool/itstool/pull/57
  resource "libxml2" do
    url "https://download.gnome.org/sources/libxml2/2.15/libxml2-2.15.1.tar.xz"
    sha256 "c008bac08fd5c7b4a87f7b8a71f283fa581d80d80ff8d2efd3b26224c39bc54c"

    # Track the version of libxml2 formula. This is not the same as `formula "libxml2"`.
    livecheck do
      url "https://formulae.brew.sh/api/formula/libxml2.json"
      strategy :json do |json|
        json.dig("versions", "stable")
      end
    end
  end

  def install
    resource("libxml2").stage do
      # We need to insert our include dir first
      includes = [formula_opt_include("libxml2")]
      includes << (OS.mac? ? "#{MacOS.sdk_for_formula(self).path}/usr/include" : HOMEBREW_PREFIX/"include")
      inreplace "python/setup.py.in", "includes_dir = [",
                                      "includes_dir = [#{includes.map { |inc| "'#{inc}'," }.join(" ")}"

      # Run configure to generate setup.py and Doxygen XML
      system "./configure", "--disable-silent-rules",
                            "--with-history",
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
    system configure, "--prefix=#{libexec}", "PYTHON=#{python3}"
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
