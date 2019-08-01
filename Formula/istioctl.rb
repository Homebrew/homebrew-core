class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.2.3",
      :revision => "c562694ea6e554c2b60d12c9876d2641cfdd917d"

  bottle do
    cellar :any_skip_relocation
    sha256 "92994139ca697aeb58af7ab236f79d3414126033022a5e04a68ac529d5ca96fc" => :mojave
    sha256 "737041bd7dfd024ff478e519980585c725ea821574dcbd431cf2562164820395" => :high_sierra
    sha256 "27354c3507137b18e38447e51aff650106525d54dba36a22e14335b2f34d230f" => :sierra
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
