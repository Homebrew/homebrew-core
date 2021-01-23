class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.0.6.tar.gz"
  sha256 "3d93c7508174d456a1d8a50f64227d243fa1226f8116c3dac6c044b246698415"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c92206e6346115583e560a14865d42d69ea1b476d6277a9bfe847299c9984bc" => :big_sur
    sha256 "53d8dc29d8607548f4b8d777eefd540ab30bdd0e12841f5ba8d7437b1952c797" => :catalina
    sha256 "ded463d59dbfa8e4661dbcf73b2d855de3aee49414c70bbac2b1492d979375f3" => :mojave
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
