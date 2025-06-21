class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  url "https://download.gnome.org/sources/libxml2/2.14/libxml2-2.14.4.tar.xz"
  sha256 "24175ec30a97cfa86bdf9befb7ccf4613f8f4b2713c5103e0dd0bc9c711a2773"
  license "MIT"

  # We use a common regex because libxml2 doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxml2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "12bbcf2668d6a0dd1493d167428acf67f262fb13b1982511eec7afadfe3d12fd"
    sha256 cellar: :any,                 arm64_sonoma:  "d9eee4e34d98f846d6dae120a51272e32a3fd8306bfd5b0bfa8d2af5fb0fb06b"
    sha256 cellar: :any,                 arm64_ventura: "3981cb3adaf892fe72ede95d825535dde86727697198bf6967999a5690eac877"
    sha256 cellar: :any,                 sonoma:        "07d9dbde746514cdabdd7b3b3ab15d26f46bff4772926f3b8f7545a7c6c5e456"
    sha256 cellar: :any,                 ventura:       "c4eb4a4ead8d6a1a214d3a3b5c01f50b492927b6c9f5f3eedd6988708bdfa2f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c82daf83bbbcf9aba0ec01e4105446845a525cf87d6ef0716769a1909ed24d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03831d3b679e963d9be90a748746b447cc52a2398dc516dfd0ed7c26f9b431cf"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxml2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => [:build, :test]
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "readline"

  uses_from_macos "zlib"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--sysconfdir=#{etc}",
                          "--with-history",
                          "--with-legacy", # https://gitlab.gnome.org/GNOME/libxml2/-/issues/751#note_2157870
                          "--without-lzma",
                          "--without-python",
                          *std_configure_args
    system "make", "install"

    sdk_include = if OS.mac?
      sdk = MacOS.sdk_path_if_needed
      sdk/"usr/include" if sdk
    else
      HOMEBREW_PREFIX/"include"
    end

    includes = [include, sdk_include].compact.map do |inc|
      "'#{inc}',"
    end.join(" ")

    # We need to insert our include dir first
    inreplace "python/setup.py", "includes_dir = [",
                                 "includes_dir = [#{includes}"

    # Needed for Python 3.12+.
    # https://github.com/Homebrew/homebrew-core/pull/154551#issuecomment-1820102786
    with_env(PYTHONPATH: buildpath/"python") do
      pythons.each do |python|
        system python, "-m", "pip", "install", *std_pip_args, "./python"
      end
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libxml/tree.h>

      int main()
      {
        xmlDocPtr doc = xmlNewDoc(BAD_CAST "1.0");
        xmlNodePtr root_node = xmlNewNode(NULL, BAD_CAST "root");
        xmlDocSetRootElement(doc, root_node);
        xmlFreeDoc(doc);
        return 0;
      }
    C

    # Test build with xml2-config
    args = shell_output("#{bin}/xml2-config --cflags --libs").split
    system ENV.cc, "test.c", "-o", "test", *args
    system "./test"

    # Test build with pkg-config
    ENV.append "PKG_CONFIG_PATH", lib/"pkgconfig"
    args = shell_output("#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs libxml-2.0").split
    system ENV.cc, "test.c", "-o", "test", *args
    system "./test"

    pythons.each do |python|
      with_env(PYTHONPATH: prefix/Language::Python.site_packages(python)) do
        system python, "-c", "import libxml2"
      end
    end

    # Make sure cellar paths are not baked into these files.
    [bin/"xml2-config", lib/"pkgconfig/libxml-2.0.pc"].each do |file|
      refute_match HOMEBREW_CELLAR.to_s, file.read
    end
  end
end
