class Ktop < Formula
  desc "Top-like tool for your Kubernetes clusters"
  homepage "https://ktop.app/"
  url "https://github.com/vladimirvivien/ktop/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "a2ee62fde8b20cdfa171ccb47be28017c9b2a623f4fbf68d4c3df3cd6803faa0"
  license "Apache-2.0"
  head "https://github.com/vladimirvivien/ktop.git", branch: "main"

  bottle do
    manifest_sha256 "4d0d877eb0b513acb895b9f87340d721c488fef55070342299d96fa438d3af47"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9af031ba22d64568a3b6c9db31c2c33c8971ae1bb075f654c26df1cff11a452"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fab40666a54bd6f9d260ab5e96dfc9609a55b00c51a2cbfeee01f29a47af988b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fa9ffbac92910df14899ee3f647b03156e477a32327f4d59da767b0a7076803e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f6158bd8b6e7e64ebbb0a3b7a8ab59442673daffa6d49ba8bf9d67a09e2e49f4"
    sha256 cellar: :any,                 x86_64_linux:      "a2703b8d31934e072689b5b2b6b44d81fb855ae71adaa772d3b42fd8122bf291"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/vladimirvivien/ktop/buildinfo.Version=#{version}
      -X github.com/vladimirvivien/ktop/buildinfo.GitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/ktop --all-namespaces 2>&1", 3)
    assert_match "connection refused", output
  end
end
