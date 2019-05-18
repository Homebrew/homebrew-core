class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.1.7",
      :revision => "eec7a74473deee98cad0a996f41a32a47dd453c2"

  bottle do
    cellar :any_skip_relocation
    sha256 "46da8d1c54d5b73ab9cc0db42f0eb44b1fb2b5cff1a2a5a5fd9d48c04a8d079e" => :mojave
    sha256 "7e212884fa4ba7e2f60218eec191737e7a34c4809c708c58849ee079043fae11" => :high_sierra
    sha256 "2b8abf826affcf4eee93e57935c05c2b8193cdb59139e33c6de085505cd097a2" => :sierra
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
