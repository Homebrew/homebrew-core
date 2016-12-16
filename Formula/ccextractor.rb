class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "http://www.ccextractor.org"
  url "https://downloads.sourceforge.net/project/ccextractor/ccextractor/0.84/ccextractor.src.0.84.zip"
  sha256 "8825849021fd8bfaa99ea63fc3c7e3f442b54450a1e50e93bf8b51627ebe60a7"
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c728f96ce60f0f7833f076c242fff1327e22fec775087d8c6dec7a1ffa34719d" => :sierra
    sha256 "cc2090ced16465dc32d2a5079364b5f3ca064222d42c177126c49b2b372336cf" => :el_capitan
    sha256 "3d6aa76b9cb91f4f67c901d4386ec8db148224b0504b8228e978d02e4a4a5587" => :yosemite
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
