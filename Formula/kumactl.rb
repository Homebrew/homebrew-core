class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.0.3.tar.gz"
  sha256 "dcdd3299d4c89d4f6f365d24be9f860e73a38a157c3e54da6e79f1b1468ba2fa"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a55d874d7aa932d9e2c1d61a6a12acbedbece0ee5346bb917a1e0775a12ec875" => :big_sur
    sha256 "e344208f0e29650d9dd51f11b30abb9de7160664412209bd941c0485d3673b97" => :catalina
    sha256 "e310ea84ccbdb1114e20758cd01fd7c190d0f1dae030ec3e094d5de7c950b108" => :mojave
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

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
