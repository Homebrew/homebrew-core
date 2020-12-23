class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.0.4.tar.gz"
  sha256 "e2c8e3ca0274f18d2698061e2f0d3e2a50d315dd984839fe2687f7be4667c754"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab3c6f43598a31342bd386a85c18ffaae96b3057e02f340180b8e81522efa9d0" => :big_sur
    sha256 "5e06b47ee99362039b12fdc705ea10722aaf1d033351551c3df38508e120561a" => :catalina
    sha256 "89d91ca5934eeef9367a45635b6d14bb4dfe81432246f968fc943123dcd34002" => :mojave
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
