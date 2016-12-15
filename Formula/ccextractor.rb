class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "http://www.ccextractor.org"
  head "https://github.com/ccextractor/ccextractor.git"

  stable do
    url "https://downloads.sourceforge.net/project/ccextractor/ccextractor/0.83/ccextractor.src.0.83.zip"
    sha256 "6ed32ba8424dc22fb3cca77776f2ee3137f5198cc2909711cab22fcc7cee470a"

    # Remove for > 0.83
    # Fix "fatal error: 'protobuf-c.h' file not found"
    # Upstream commit from 15 Dec 2016 "Added missing directory for protobuf-c."
    patch do
      url "https://github.com/CCExtractor/ccextractor/commit/6e17633.patch"
      sha256 "1a23b3e48708e60d73fffa09bb257b421ad2edab7de3d8d88c64f840c16564b3"
    end
  end

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
