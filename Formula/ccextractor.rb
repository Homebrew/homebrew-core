class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "http://www.ccextractor.org"
  url "https://downloads.sourceforge.net/project/ccextractor/ccextractor/0.82/ccextractor.src.0.82.zip"
  sha256 "890e7786256c74c7e4850592784da027451dd7c3e3a353c9bad3bea5467b7b77"
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9b4e38e0b81d257841d64eb8aeec6e3015d1ad7ac9afe3d8b797f969109960d" => :sierra
    sha256 "358c85300067eb0ae9a7b09d2325c24103ecbdf73f2d07c8e76baaeac5743931" => :el_capitan
    sha256 "e5dfe6c34730149839a16860fb012776633dc0021562d26a6f06a5825116ee3c" => :yosemite
    sha256 "b513081333efed3bf23e133bd062c18507b587a627379693a14372c45b966d6b" => :mavericks
  end

  def install
    cd "mac" do
      system "./build.command"
      bin.install "ccextractor"
    end
    (pkgshare/"examples").install "docs/ccextractor.cnf.sample"
  end

  test do
    touch testpath/"test"
    system bin/"ccextractor", "test"
    assert File.exist?("test.srt")
  end
end
