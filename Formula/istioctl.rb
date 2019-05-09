class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.1.5",
      :revision => "9b6d31b74d1c0cc9358cc82d395b53f71393326b"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f70201d0038474334b31251f62953be78c95e6f9d5b9a0b8d89dd4e988f83c7" => :mojave
    sha256 "688852ec222d80faf449765ad007b909e4b08975c915163fd37ca02283fdca4d" => :high_sierra
    sha256 "52bc8522c996f2cef35daabc1c6180ffd1b01da468c78d8a23cbb11a04479851" => :sierra
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
