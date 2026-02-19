class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.21.tar.xz"
  sha256 "7908ec9bec2c2a811d822e1395e0958702f89de93de5bba3b12fa987ff3e2549"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "406ce007a947338561603c947bd90b810c98e1a0ecc6035a9d065332c7634f7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "406ce007a947338561603c947bd90b810c98e1a0ecc6035a9d065332c7634f7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "406ce007a947338561603c947bd90b810c98e1a0ecc6035a9d065332c7634f7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "87f4dc1ebc0140430fd3fc8c44a746c2e6ae26bddb78061eb2f70178211797ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91d02743734b833ed4bb84570d1816885ec66f7efaa3cef1c84e87cc9d0902bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0dff8efa3ec92b75424205575111012ef09cf30c34876fd41ec66511e7b4acd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"

    generate_completions_from_executable(bin/"incus", shell_parameter_format: :cobra)
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
