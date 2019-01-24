class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  url "https://github.com/bcicen/ctop/archive/v0.7.2.tar.gz"
  sha256 "bb40939b3d420864db6abc82e885a755f6de5b2e84eef3c7b956a8508f931811"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c581ea1e2572f43ac4410fcbb5f39e706a031d45998ad54cc1ba474fa2c1cb1" => :mojave
    sha256 "0d2f00fb47786a5a95578da90f80979683e76d431ad90c62088d082af4ecdeff" => :high_sierra
    sha256 "3d3968570b78e240fe94f16eb4235f016ba1f5943e3030eb177b0a7a71989934" => :sierra
    sha256 "149adb4dfa66b7492992c07f1007743f69a6069d380a43d0e14dfffba7bc8988" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/bcicen/ctop").install buildpath.children
    cd "src/github.com/bcicen/ctop" do
      system "make", "build"
      bin.install "ctop"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/ctop", "-v"
  end
end
