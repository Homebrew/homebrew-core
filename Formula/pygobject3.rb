class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.22/pygobject-3.22.0.tar.xz"
  sha256 "08b29cfb08efc80f7a8630a2734dec65a99c1b59f1e5771c671d2e4ed8a5cbe7"

  bottle do
    cellar :any
    sha256 "a692ad183982ec8bb0474b1c1505d9db1e23ecb9d3d5eaa71c97a6953ae158ab" => :sierra
    sha256 "548357d70cfa8b7392e118d447cda25a89e9aa4ba49ee6f7b8f60fb119b84a3d" => :el_capitan
    sha256 "ac9f149c4d46f9530123fad0132ac7e1edf146d1d4806ba8a7673753f846ebc5" => :yosemite
    sha256 "84ef031a8bfb645bc51f4bc327695271121f382981e88dd90f33d8e8ed56ef61" => :mavericks
  end

  option :universal
  option "without-python", "Build without python2 support"

  depends_on "pkg-config" => :build
  depends_on "libffi" => :optional
  depends_on "glib"
  depends_on :python3 => :optional
  depends_on "py2cairo" if build.with? "python"
  depends_on "py3cairo" if build.with? "python3"
  depends_on "gobject-introspection"

  def install
    ENV.universal_binary if build.universal?

    Language::Python.each_python(build) do |python, _version|
      system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "PYTHON=#{python}"
      system "make", "install"
      system "make", "clean"
    end
  end

  test do
    Pathname("test.py").write <<-EOS.undent
    import gi
    assert("__init__" in gi.__file__)
    EOS
    Language::Python.each_python(build) do |python, _version|
      system python, "test.py"
    end
  end
end
