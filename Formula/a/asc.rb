class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/7.7.0.tar.gz"
  sha256 "d87d7041612a0e1e9bb2591589643446fe5e22e1f65efb273f6c0a1ca30e75ee"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    manifest_sha256 "78148f91cafd3fb9494f05456257597b307a4a61faa8c927d767bb1d57963b8e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5147219217a66b3aa2b91e721b9351294ab900d61950f9716ecf212778a1a059"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e6eeb1e4823e9208546e7c5520d72d10cb95b1720205e8189fe9904abcea73e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9bf2a283e1b1851094f097cd64e2986dad60e9c0446c0d7cbba32bd841453b64"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6a8054184a7e7a1e39d8b667489b0294f4be3cc0f8717cb9a70d2548b8084808"
    sha256 cellar: :any,                 x86_64_linux:      "5b71138062d43fddb28dbb43945928ef581d5b4d9fb7071b5d6edf339554559f"
  end

  depends_on "go" => :build

  conflicts_with "asccli", because: "both install `asc` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
