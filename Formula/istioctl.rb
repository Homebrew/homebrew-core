class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.3.0",
      :revision => "c2bd59595ce699b31d0f931885f023028ff7902b"

  bottle do
    cellar :any_skip_relocation
    sha256 "a52ce214a65325356946c7d27b89f3e730a40ce2969807a613a776e748774c9d" => :mojave
    sha256 "2a4e330945618ac2fb2009a2e6f282d2ed5023627471cd6a6a03798596696a27" => :high_sierra
    sha256 "48144f9cd3eff46fad23a5bc84d2e7975774f66f0ceabb24934ef7696779997f" => :sierra
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
