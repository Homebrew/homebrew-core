class Lazydocker < Formula
  desc "Lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "405071220e5be9aa061c65d290e0347143b73ae0a3cc01df164f0105de2b53c4"
  license "MIT"
  head "https://github.com/jesseduffield/lazydocker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8522a4229dea2b63f88c29a5772f5ba7321bd8637c6dee299e266a14c29cffe5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8522a4229dea2b63f88c29a5772f5ba7321bd8637c6dee299e266a14c29cffe5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8522a4229dea2b63f88c29a5772f5ba7321bd8637c6dee299e266a14c29cffe5"
    sha256 cellar: :any_skip_relocation, sonoma:        "68b8d5ae390f69c33aed50d4089b4d7a8087e27110b172e065f8e84efea08584"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6266094262f876ff6e9209f067d25587d1845904c98de4fa478106a8e942d32f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "491c528838ce7c9209659601a4aa742785fde0b8a22b7dd4c556d6952ecbcb58"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.buildSource=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "language: auto", shell_output("#{bin}/lazydocker --config")
  end
end
