class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/40.0.2.tar.gz"
  sha256 "1bfb6664c0adba8ff12618e7dd9334921f3c9e5e41c7724027c0949fce826347"
  license "MIT"
  head "https://github.com/antonmedv/fx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7396f31aaca62426621e1028295db2f2169b37f5ac6c7d8ba5d8b4857ad4660a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7396f31aaca62426621e1028295db2f2169b37f5ac6c7d8ba5d8b4857ad4660a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7396f31aaca62426621e1028295db2f2169b37f5ac6c7d8ba5d8b4857ad4660a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d5d0c818c21dc49a0a32c1a3388817da0047274f1e8c34445714baf90b80b8fd"
    sha256 cellar: :any,                 x86_64_linux:      "e35c035c6d8db37f32b33356911a2858907721fffb3ea844f727aa37cfe6fb11"
  end

  depends_on "go" => :build

  conflicts_with "fx-agent", because: "both install an `fx` binary"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
    generate_completions_from_executable(bin/"fx", "--comp")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", "42").strip
  end
end
