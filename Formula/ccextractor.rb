class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "http://ccextractor.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ccextractor/ccextractor/0.81/ccextractor.src.0.81.zip"
  sha256 "54c7dbebe23670b2dabd87a5a141dee748439c4015a75f0a9c9e389708300d3d"
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    cellar :any
    revision 1
    sha256 "08ca272b7c1ab7ee1945654a896282ed6c5f19651bbc5dc02e6ad7d71039456c" => :el_capitan
    sha256 "10ad588c435ec6b4a0c1f6f8dea8603024100f404727b30c01e939fdc16f88ad" => :yosemite
    sha256 "f353febd41be9199e791aedf219fb15d506a10928a86782c7afeab766d470a2f" => :mavericks
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
