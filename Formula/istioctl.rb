class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.1.9",
      :revision => "879413c25b871ae6fd0df82bea1605baf12cba2e"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7ac23ec1c8e84fc36c31e6edfcfbd7aafbd9c39f3e4a3e935541d90544c88e9" => :mojave
    sha256 "21ff69eff51e99fe6f974232796df2bc48cde9d1fdce1e6ef88137e2276bf1ad" => :high_sierra
    sha256 "93c21981e32a4c539a3b73d7de401380049328e417b57dd1fb62757adbd1e60b" => :sierra
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
