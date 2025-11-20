class Pastebinit < Formula
  include Language::Python::Shebang

  desc "Send things to pastebin from the command-line"
  homepage "https://github.com/pastebinit/pastebinit"
  url "https://github.com/pastebinit/pastebinit/archive/refs/tags/1.7.1.tar.gz"
  sha256 "8e91c2c0d02a41faaa40d9f585fe858893c3f0ef94836ee4ce14094cfc10b938"
  license "GPL-2.0-or-later"
  head "https://github.com/pastebinit/pastebinit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "89be086efffd69157222144a6a0606ba775daaf156927cfde6aae9d2fadec2ae"
  end

  depends_on "docbook2x" => :build
  depends_on "gettext" => :build # for msgfmt

  uses_from_macos "python"

  def install
    inreplace "pastebinit", "confdirs = []", "confdirs = ['#{pkgetc}/pastebin.d']"
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "pastebinit"

    bin.install "pastebinit", *buildpath.glob("utils/*{s,t}")
    pkgetc.install "pastebin.d"

    system "docbook2man", "pastebinit.xml"
    man1.install "PASTEBINIT.1" => "pastebinit.1"
    man1.install buildpath.glob("utils/*.1")

    system "make", "-C", "po"
    (share/"locale").install (buildpath/"po/mo").children
  end

  test do
    url = pipe_output("#{bin}/pastebinit -a test -b paste.ubuntu.com", "Hello, world!").chomp
    assert_match "://paste.ubuntu.com/", url
  end
end
