class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.1.3",
      :revision => "d19179769183541c5db473ae8d062ca899abb3be"

  bottle do
    cellar :any_skip_relocation
    sha256 "8101cc3e74ded429e6b5f1ecf75a34c5aa1fcd57ae3b449fcb02ce7745a40968" => :mojave
    sha256 "f226b7ec698aceee50ee02241b3f01a6ab61b199974c32760bae05bdb6a089b4" => :high_sierra
    sha256 "7ee49fee89caf8155d3018c4a8f666dd175d0f6fd3de0071d0eefdfa6e1a83ba" => :sierra
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
