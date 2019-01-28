class Goc < Formula
  desc "wrapper for the go client that correctly builds Go applications using packages from GoCenter without the need for manual setup."
  homepage "https://github.com/jfrog/goc"
  url "https://github.com/jfrog/goc/archive/v1.0.1.tar.gz"
  sha256 "903a0deadb1729c2ed20b438f2d8efc1041a4ddf78bdee494eb78fa2456e055f"

  bottle do
    cellar :any_skip_relocation
    sha256 "a91281eafc31d9940d7e031b62a177ee370c68c7f72f9442a49478e83c2f3003" => :mojave
    sha256 "caeb3dfb55d07b30dcc88ed6246fff83b8785000d07a59c7ec4ea65809ae174e" => :high_sierra
    sha256 "3bc26e2af76236ce5f5b0b70b642556a934a6fe23e22c9de9d97387bc4fff5e1" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jfrog/goc").install Dir["*"]
    cd "src/github.com/jfrog/goc" do
      system "go", "build", "-o", bin/"goc", "main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goc -v")
  end
end
