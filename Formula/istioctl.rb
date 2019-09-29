class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.3.1",
      :revision => "12c4d01552363362b49fce86f83b847b308b9b0d"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3263850fb16f131de3cd7fca0a927125571c28f5a0098f55d16cf47132b3029" => :catalina
    sha256 "2edbb3609acba191219917a38d398b3e60a0e43ad947097f21f2c94f202bd66f" => :mojave
    sha256 "0a4da44d939344dd1c4f527a6ce49b175be0786207feec9d358ac4c0e2aa5531" => :high_sierra
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
