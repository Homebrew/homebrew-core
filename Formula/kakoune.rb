class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2018.09.04/kakoune-2018.09.04.tar.bz2"
  sha256 "7a31c9f08c261c5128d1753762721dd7b7fe4bb4e9a3c368c9d768c72a1472e1"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "50176fd868ebf3bf357ec583000d9dff76e6a155dc2457518630d5e2b1e16a56" => :mojave
    sha256 "16dfec7140e99f6780b24d81fc45bb7a8703dce51e8ebe080b7d73f855126615" => :high_sierra
    sha256 "ab41d37bb6e4d47208eea741354b09a48ffbe8ea5a32f88456a60643738c6f8c" => :sierra
    sha256 "6122fb695a150e34742fcb544f92b9261180730ec335f3ee730bcc7f5d7e2db4" => :el_capitan
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build

  if MacOS.version <= :el_capitan
    depends_on "gcc"
    fails_with :clang do
      build 800
      cause "New C++ features"
    end
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    cd "src" do
      system "make", "install", "debug=no", "PREFIX=#{prefix}"
    end
  end

  test do
    system bin/"kak", "-ui", "dummy", "-e", "q"
  end
end
