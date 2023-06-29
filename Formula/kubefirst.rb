class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.1.7.tar.gz"
  sha256 "5e408484d14c483e5f9ca994d680bfb45fee1ee2e64f4d6f40f6747a833a0d53"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c867493559ca7d86ccd481358b72e394c264cdc2d8b15ef090c6f29a3c48d2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e47c58bed9049914ef7a5354466c8425db3bca5144b2fd0664accc30f6eab96e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33ce5fdc7ddcb6a84a964f7347446fb382501761ad98387d91e08024949053ad"
    sha256 cellar: :any_skip_relocation, ventura:        "1e9465618be6ef92ad47bbc13c9ab12a4b623edd09bfce84ff19a0dd82233fd2"
    sha256 cellar: :any_skip_relocation, monterey:       "46b251aa0a31c3e5b4393dc1b8f55325be795de880587a2a17d0659db2cd550b"
    sha256 cellar: :any_skip_relocation, big_sur:        "91429c1f1b29e9cc7027813a589772b6de094accd6bfaf1d69092dcb5d125afe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8847be392d1c542da7b7d09bd8f9b32849b9be70d8db7c6ef57c78e48f504bf2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/runtime/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    assert_match "v#{version}", shell_output("#{bin}/kubefirst version")
  end
end
