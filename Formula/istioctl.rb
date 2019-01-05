class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.0.5",
      :revision => "c1707e45e71c75d74bf3a5dec8c7086f32f32fad"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5ac5d268b626cfd6119a90876a150925d35b5aa0f70c3d6fb91034e23e747444" => :mojave
    sha256 "08a48f07489f27df6de1df7f49bba30ae57a7be21c5eb3baee5b3ccdac8ad669" => :high_sierra
    sha256 "97da2fa6441d6d6bc534962e095338ce0b7d76a4859af36c3979a46b5e80e8c7" => :sierra
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
