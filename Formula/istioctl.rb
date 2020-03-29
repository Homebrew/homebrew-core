class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.5.1",
      :revision => "9d07e185b0dd50e6fb1418caa4b4d879788807e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "f12671b853ba1a12be44d2d78beeb7b880fa158be33b426e1785998d02726735" => :catalina
    sha256 "f12671b853ba1a12be44d2d78beeb7b880fa158be33b426e1785998d02726735" => :mojave
    sha256 "f12671b853ba1a12be44d2d78beeb7b880fa158be33b426e1785998d02726735" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"

    srcpath = buildpath/"src/istio.io/istio"
    outpath = srcpath/"out/darwin_amd64"
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
