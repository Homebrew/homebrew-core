class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.0.tar.gz"
  sha256 "8a7b278b93b737daf46554fa83b86538b1f6eee02f8508eb08581aa578531f02"

  bottle do
    cellar :any_skip_relocation
    sha256 "b502e75cb3bc36d562d342650766ef432b8823d7f14898ef57085fc9c939537f" => :catalina
    sha256 "991527aa84e63ac9e1e0c3693c041339aed014f4441fb5c862b9ce9a4a32c419" => :mojave
    sha256 "c3d57bbdd88cfdd3f212c68f73350afd5969b471d928f4ea6aa30d7545e2618d" => :high_sierra
  end

  depends_on "go" => :build

  resource "test" do
    url "https://raw.githubusercontent.com/mmarkdown/mmark/master/rfc/2100.md"
    sha256 "0b5383917a0fbc0d2a4ef009d6ccd787444ce2e80c1ea06088cb96269ecf11f0"
  end

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/mmarkdown/mmark").install buildpath.children
    cd "src/github.com/mmarkdown/mmark" do
      system "go", "build", "-o", bin/"mmark"
      man1.install "mmark.1"
      prefix.install_metafiles
    end
  end

  test do
    resource("test").stage do
      assert_match "The Naming of Hosts", shell_output("#{bin}/mmark -ast 2100.md")
    end
  end
end
