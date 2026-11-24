class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "f58acaaff784ae5fa68bfede3630d03d53b0d4015697edad82dc3f75792a97ab"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    manifest_sha256 "e2a9b3d19d82cfb0f8e0e14cd8c44392941b76f3c8390adc720de0a9e1f7f805"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "677df04fb97c74c8cbea11c743ce2e3dcf9400295da99ab88a1d58d607fc0ecd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "677df04fb97c74c8cbea11c743ce2e3dcf9400295da99ab88a1d58d607fc0ecd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "677df04fb97c74c8cbea11c743ce2e3dcf9400295da99ab88a1d58d607fc0ecd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "68bd51e3eafe58c0329cb74aca6641aadb460b593b22824bdb2d4c512951b2af"
    sha256 cellar: :any,                 x86_64_linux:      "b4cd2b6a8be58827b715e70c7893f2a4b73e93b75f3e87f83eb6c8c7d4f05e66"
  end

  depends_on "go" => :build

  conflicts_with "deja", because: "both install `deja` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"deja"), "./cmd/deja"

    generate_completions_from_executable(bin/"deja", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deja version")
    assert_match '"schema_version": 2', shell_output("#{bin}/deja doctor --json --offline")
    assert_match "no matches", shell_output("#{bin}/deja search nothing-is-indexed-here 2>&1")
  end
end
