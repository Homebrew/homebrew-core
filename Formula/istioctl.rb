class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.0.6",
      :revision => "98598f88f6ee9c1e6b3f03b652d8e0e3cd114fa2"

  bottle do
    cellar :any_skip_relocation
    sha256 "21b5b057c1d5b8a024f7330199155ae06dcf47021ab51a974d37624f15d3f531" => :mojave
    sha256 "1bfa5a5801a65e404cfd5b70e8584e275000b39d5383db98b064bb51c0048a12" => :high_sierra
    sha256 "c7586d1827616da703e2c808a3b1a012ad3377df55f59f204b35b7ea5f756b1a" => :sierra
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
