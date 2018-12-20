class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio/archive/1.0.5.tar.gz"
  sha256 "48418c5f27ef61403aea79ea57c502cec426117a5de4db713cd3691e2bf91204"

  bottle do
    cellar :any_skip_relocation
    sha256 "60f54ee59267e538d21fe4d27e92f5483762e562233d362c1b97b65fa6560848" => :mojave
    sha256 "e01e92dfc83e193f1580b908a3fb923382d331f9631c619247638e3e3510a164" => :high_sierra
    sha256 "1e25ee825d4e23fd07d08e8809ff73b0d4346c0b6f12552c544a5fbcae206fdd" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TAG"] = version.to_s

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
