class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  url "https://github.com/bcicen/ctop/archive/v0.7.2.tar.gz"
  sha256 "bb40939b3d420864db6abc82e885a755f6de5b2e84eef3c7b956a8508f931811"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e168b17be6893484012554531584934ddcb4c41a81ff5ffe9ff6b72f8a24d39" => :mojave
    sha256 "eccc5c1766fc7c558b313f3c4d928615176e252e12dcc329d985c4320feb5813" => :high_sierra
    sha256 "fa9113c826584235dfbe6e96092c3c0fe74dfb5ae37719b0f5f1726191f3f051" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"
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
