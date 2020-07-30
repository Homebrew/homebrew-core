class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/0.7.0.tar.gz"
  sha256 "fe88dcedcd90f157265637af3db7b3e54cf77d06a21e4b0f6eeeda9a89c3fa57"
  license "Apache-2.0"

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
