class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.0.2.tar.gz"
  sha256 "14db4d8874474749547ec6fd69c902f55f6d8d90cc5fc9ed21a6f4ad3f1d0592"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d94773626387f59d67fabd8d8b14bba71e3784766f8e89aecce698f82279ccb1" => :big_sur
    sha256 "95c406b214840cdbb27ecf48c719f3ad235579ea4685e70d28c4e467d7e771ef" => :catalina
    sha256 "5fabd5e59159a52d577ead7416a12c684c994aa51ce5b895ca2cba33b2140f8e" => :mojave
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
