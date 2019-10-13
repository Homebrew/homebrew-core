class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.3.3",
      :revision => "3cfabd9b36bcf9b5af3c390982772e8f1e798618"

  bottle do
    cellar :any_skip_relocation
    sha256 "170311969b82399ab7c928aaf11ad0b12da05991d3e185fa1117a21d6d3ad1c7" => :catalina
    sha256 "fe9cc9e8345cf9e584a551617abdc677b20f3114ed0662cf63106f0f042810dd" => :mojave
    sha256 "23ea12659ba6e0b1059e489d7cdfa29be5ff4d370148b5fec085b987359c49a9" => :high_sierra
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
