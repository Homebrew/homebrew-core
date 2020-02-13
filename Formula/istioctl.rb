class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.4.4",
      :revision => "30c10500ee49689826b87db65db133cbc4a7f52a"

  bottle do
    cellar :any_skip_relocation
    sha256 "661348a8ce82de4df9817207357d1d600b97c6feaa76db63e6f38e7a297abdd4" => :catalina
    sha256 "661348a8ce82de4df9817207357d1d600b97c6feaa76db63e6f38e7a297abdd4" => :mojave
    sha256 "661348a8ce82de4df9817207357d1d600b97c6feaa76db63e6f38e7a297abdd4" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"

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
    assert_match version.to_s, shell_output("#{bin}/istioctl version --remote=false")
  end
end
