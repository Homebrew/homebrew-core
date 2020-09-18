class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      tag:      "1.7.2",
      revision: "a8c04f92e236676977b3ed58132437d9fafc9aed"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "40417e64c1a6f864aaa256dd76c31aed65623be7c6b15e6d0808382f7e73a557" => :catalina
    sha256 "75dff65ccf186e8dae4d9a217619add0a82524bf74198abf12377041f28a8d42" => :mojave
    sha256 "49fcc2f4f66e99e9b8341c6fc4616c0cd4341222ad1447ff2368c9028b58b68b" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    system "make", "gen-charts", "istioctl", "istioctl.completion"
    cd "out/darwin_amd64" do
      bin.install "istioctl"
      bash_completion.install "release/istioctl.bash"
      zsh_completion.install "release/_istioctl"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/istioctl version --remote=false")
  end
end
