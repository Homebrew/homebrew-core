class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.2.1",
      :revision => "bbe7afd4d157ac105e84b6b9fc9cb695f188c684"

  bottle do
    cellar :any_skip_relocation
    sha256 "6986d77e7093e7eb5cf8944cae6eef7cf1c102f940fcf9447a06fd7f50332a9f" => :mojave
    sha256 "0cfa110527586939105bd1d8c369594ed430be8142bd650a3d9301c0b917f24a" => :high_sierra
    sha256 "8362b4875d0f78f42f0ffc6531d4c1ca5fd16662fa7d1f5d83e7f3e99a68451a" => :sierra
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
