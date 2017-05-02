class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "https://www.ccextractor.org/"
  url "https://downloads.sourceforge.net/project/ccextractor/ccextractor/0.84/ccextractor.src.0.84.zip"
  sha256 "8825849021fd8bfaa99ea63fc3c7e3f442b54450a1e50e93bf8b51627ebe60a7"
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "24f24fc570ae8cf9e846d7f58080593903f73d7b97e028f75f602e0c6f7f1bd7" => :sierra
    sha256 "12983851e7a4d513ebefabe5bbbbd3ee8f4cf5182fa247cc9c90f39c7c0390da" => :el_capitan
    sha256 "90704ba1dff668c08889cdcfc18ae80c1f130e4230dbbebb475967fbffca009f" => :yosemite
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
