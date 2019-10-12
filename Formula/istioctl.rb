class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.3.3",
      :revision => "3cfabd9b36bcf9b5af3c390982772e8f1e798618"

  bottle do
    cellar :any_skip_relocation
    sha256 "8af8c140c474e74edd0ca63d25fc97ea8ad428c926b90adfd69e376787d24f7c" => :catalina
    sha256 "2c0db1ea4ec4a53cac76e3ecf2c32dbdf848b8873032824e89f62e7975691daf" => :mojave
    sha256 "ed53ef88a88980d465ad6dcb5ef1038bca04eb1eeb023baadb287e316b04c186" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s

    srcpath = buildpath/"src/istio.io/istio"
    outpath = buildpath/"out/darwin_amd64/release"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "istioctl"
      prefix.install_metafiles
      bin.install outpath/"istioctl"
    end
  end

  test do
    assert_match "Retrieve policies and rules", shell_output("#{bin}/istioctl get -h")
  end
end
