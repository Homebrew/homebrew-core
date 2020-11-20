class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      tag:      "1.8.0",
      revision: "c87a4c874df27e37a3e6c25fa3d1ef6279685d23"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "88f6d7e0f39b30e8c332084ae13d2ccc23ca8fe076091ce69e390797acd2b253" => :big_sur
    sha256 "1ad667d0a4b954fc76ffde408e71f63028498db1bc36ccdc46dadc9e55b70147" => :catalina
    sha256 "b77f393e1d3add2434cf91c10647a8db06ab3db99c7efb869198c5184903a7d6" => :mojave
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
    assert_match version.major_minor.to_s, shell_output("#{bin}/istioctl version --remote=false")
  end
end
