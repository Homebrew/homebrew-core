class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.1.6",
      :revision => "04850e14d38a69a38c16c800e237b1108056513e"

  bottle do
    cellar :any_skip_relocation
    sha256 "863769e62aa40a78cc707fb416a235b417a4ab0645204804e7743048486c3506" => :mojave
    sha256 "a203ad21747fa158ec0d44afd4628614c11ec24e982e151797793b9bda99e9ee" => :high_sierra
    sha256 "32df7d2a2f46495f855acabc1ccfde1ca6e376f48f9865c87028e4fd2773ec15" => :sierra
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
