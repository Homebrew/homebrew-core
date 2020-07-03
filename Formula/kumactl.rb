class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/Kong/kuma/archive/0.6.0.tar.gz"
  sha256 "c9087793f10ce094ae2910bffae62b5df8f108854d9b8950fa8bdc74f058b3da"

  bottle do
    cellar :any_skip_relocation
    sha256 "63c8e3034a5a549b768dd7103fc7b390317e02e336f5f13b858aa050d3a4356b" => :catalina
    sha256 "d284fa873525a9e5f0abed0f3c1bcbe2a0be14ebe667d08e52185749d660136f" => :mojave
    sha256 "5d680c089eea27d8c03f26006a4c74eb321c84bb3f96608cec22063b663f69ca" => :high_sierra
  end

  depends_on "go" => :build

  def install
    srcpath = buildpath/"src/kuma.io/kuma"
    outpath = srcpath/"build/artifacts-darwin-amd64/kumactl"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "build/kumactl", "BUILD_INFO_VERSION=#{version}"
      prefix.install_metafiles
      bin.install outpath/"kumactl"
    end
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config"
    assert_match "Error: YAML contains invalid resource: Name field cannot be empty",
    shell_output("#{bin}/kumactl apply -f config 2>&1", 1)
  end
end
