class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.4.0",
      :revision => "c4def934e4f8d1feb42725da41ee0078cde8397f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "68dcc7f4e8fd509cc3093e8168ae688c4a3bf0dc65340bb56ee3036686d8309a" => :catalina
    sha256 "68dcc7f4e8fd509cc3093e8168ae688c4a3bf0dc65340bb56ee3036686d8309a" => :mojave
    sha256 "68dcc7f4e8fd509cc3093e8168ae688c4a3bf0dc65340bb56ee3036686d8309a" => :high_sierra
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
