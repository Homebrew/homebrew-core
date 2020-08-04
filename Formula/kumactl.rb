class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/0.7.0.tar.gz"
  sha256 "fe88dcedcd90f157265637af3db7b3e54cf77d06a21e4b0f6eeeda9a89c3fa57"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "93f86603b24a999b0bb291de1c970a48f2c789175f47a622e9022f12d31b3ffe" => :catalina
    sha256 "cf451675168150c90f3eb2fcade9ef23ffcc5199a1b869c306840b059ba4619d" => :mojave
    sha256 "6642d08d4e5aa1e34354db6ed780bf2a045e8143d3394f891fbc74bdf58884e5" => :high_sierra
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
