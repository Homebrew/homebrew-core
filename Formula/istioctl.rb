class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.4.3",
      :revision => "17f6bfc3d7121ad527c2d617ffc27c758d6a7241"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5666f84effa22938666cd051b98f4a36e2fbe4521bce3c77ee5e2125b4ee836" => :catalina
    sha256 "f5666f84effa22938666cd051b98f4a36e2fbe4521bce3c77ee5e2125b4ee836" => :mojave
    sha256 "f5666f84effa22938666cd051b98f4a36e2fbe4521bce3c77ee5e2125b4ee836" => :high_sierra
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
