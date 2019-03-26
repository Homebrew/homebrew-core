class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.1.1",
      :revision => "2b1331886076df103179e3da5dc9077fed59c989"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3c5f582b4be01a35592766252518535f7249e2fff94fb1ed8183e372a7d1b66" => :mojave
    sha256 "92ed82312f46c58741986580f05f696f3291cfcb0ead75c4aa69994fc9e93c08" => :high_sierra
    sha256 "de761a23059c8856842d348c3e9c2b5d27f685d84fe26932522384cfcffe9cc6" => :sierra
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
