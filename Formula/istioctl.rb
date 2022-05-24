class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.13.4",
      revision: "202e88863858342eeb0206944e9d277a545eb194"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b60b0b25949fb33eb461adfa9a29e7257f6c9e9a343c5432092b4783a780fc4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b60b0b25949fb33eb461adfa9a29e7257f6c9e9a343c5432092b4783a780fc4c"
    sha256 cellar: :any_skip_relocation, monterey:       "1fb1ccf13934994ec20e9f8cc93aa4f887c2b6ccb5eab56f1528cd5a22d922eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fb1ccf13934994ec20e9f8cc93aa4f887c2b6ccb5eab56f1528cd5a22d922eb"
    sha256 cellar: :any_skip_relocation, catalina:       "1fb1ccf13934994ec20e9f8cc93aa4f887c2b6ccb5eab56f1528cd5a22d922eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8106f75f81a7481cfe1ef288556ce1e19af02f6c89e372803379d383f540b813"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  uses_from_macos "curl" => :build

  def install
    ENV["VERSION"] = version.to_s
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s

    system "make", "istioctl"
    bin.install "out/#{os}_#{arch}/istioctl"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"istioctl", "completion", "bash")
    (bash_completion/"istioctl").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"istioctl", "completion", "zsh")
    (zsh_completion/"_istioctl").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"istioctl", "completion", "fish")
    (fish_completion/"istioctl.fish").write output
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end
