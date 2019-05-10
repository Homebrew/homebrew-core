class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.1.6",
      :revision => "04850e14d38a69a38c16c800e237b1108056513e"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb8284d627286cf298731a42954dbe65cf65b6f64c0d3ba7dc8b2517a1dfba93" => :mojave
    sha256 "99a80628eb2da73c2e8c513828b5937268ebe792ea7d1e1cdb395b779835895b" => :high_sierra
    sha256 "1c8a41e028cc1633f83b32a78d664b3f2679c3e63374310f3400b2f3b1a496a6" => :sierra
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
