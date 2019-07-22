class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v2.7.1.tar.gz"
  sha256 "835fef2148e586ca81cd6116861baaada94f7c0b5bda37dcf14ca666544cb0f9"

  bottle do
    cellar :any_skip_relocation
    sha256 "4329177a02a45797347832ba8b03ff878985a4e02fb27b5fc2cbb3a807013e56" => :mojave
    sha256 "9e9e4d90a8d90723ebfabcc67f2d57f992a447a8be9fb2a1e9fd162803a52c99" => :high_sierra
    sha256 "dba819dea555eed245a016284ace4c4abdbe0249bef49e2b8e32edf881e75eea" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/go-acme/lego").install buildpath.children
    cd "src/github.com/go-acme/lego/cmd/lego" do
      system "go", "build", "-o", bin/"lego", "-ldflags",
             "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
