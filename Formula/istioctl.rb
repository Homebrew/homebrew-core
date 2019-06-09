class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.1.8",
      :revision => "145b18a441045d6fad33d7916380d8642c7bf21d"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f7e60163cd11f1a6688ec87b1b851c8c8c9da85888bda23dd3ceb607a6b260f" => :mojave
    sha256 "ae4b0bc2f1f2fd7b8508f500b52cdd19dcef65915fb228db0ddce6d85ea421f3" => :high_sierra
    sha256 "ba0281d520d07cc059766ab676d2324e3fb0c9a0c67e30480a746291dcaf0ccc" => :sierra
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
