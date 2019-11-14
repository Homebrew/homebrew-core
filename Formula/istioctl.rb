class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.4.0",
      :revision => "c4def934e4f8d1feb42725da41ee0078cde8397f"

  bottle do
    cellar :any_skip_relocation
    sha256 "25d58c73b64719217c1ed1242ea70a37fd94eb09d445e911cde8a20b2e17518b" => :catalina
    sha256 "e0b1f22c2778d844617d925c5e59f869dba5959ccb979f7a5801f3fd71dddac2" => :mojave
    sha256 "f81b261f7abac7fbc8df7ccb2493e54184af9e1cb305b3096dd23b51bfbd0697" => :high_sierra
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
