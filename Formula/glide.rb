class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/v0.12.3.tar.gz"
  sha256 "a304c29267cf7e00b7299b6ac8da0317f2f4f4096acb6cf817d4c745e0dee8b4"

  head "https://github.com/Masterminds/glide.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ffe9893d80a07efb04e55922b14ea86e8a2eb480bbab0c2122ae6797c0465040" => :sierra
    sha256 "13484c8842708784a077477dbdc6c5b39836ddbcbf00d2ffdfe15044e4772812" => :el_capitan
    sha256 "fb569cf720820ae1e11d027b730d11244a5f7fe3ecff1c8bb6533209b03053a4" => :yosemite
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    glidepath = buildpath/"src/github.com/Masterminds/glide"
    glidepath.install buildpath.children

    cd glidepath do
      system "go", "build", "-o", "glide", "-ldflags", "-X main.version=#{version}"
      bin.install "glide"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/glide --version")
    system bin/"glide", "create", "--non-interactive", "--skip-import"
    assert File.exist?("glide.yaml")
  end
end
