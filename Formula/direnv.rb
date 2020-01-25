class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.21.0.tar.gz"
  sha256 "0dd3c28c43bf411a70d65bc34f91dfe59f772b99816b999ab6481eb64b2a8573"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "63210cfbbd0febcb18f3c48b460a1a446f19ee9682566a78b7c44f3d289eed83" => :catalina
    sha256 "548dc9aab0d941ce4bb15b5f5b0de0c70308cdebc2c6af8d54a644e57e71ffa5" => :mojave
    sha256 "eb6c47a8999d698a81032a4d5f60053ea898251575a79e95fcaeb35dcb15c6cb" => :high_sierra
    sha256 "6e5aea68152027b0117319dadf8ecdcc0183815073ea8dbfab10e7bf5967047c" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/direnv/direnv").install buildpath.children
    cd "src/github.com/direnv/direnv" do
      system "make", "install", "DESTDIR=#{prefix}"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"direnv", "status"
  end
end
