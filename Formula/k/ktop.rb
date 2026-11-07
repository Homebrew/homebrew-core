class Ktop < Formula
  desc "Top-like tool for your Kubernetes clusters"
  homepage "https://ktop.app/"
  url "https://github.com/vladimirvivien/ktop/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "320763bac3edc8922c3f78c0469c37c438650f83299564da12d22d6d7515a3ea"
  license "Apache-2.0"
  head "https://github.com/vladimirvivien/ktop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c0743d0ae409a0770df5770ede6aed5ac706525a883acf82918037fa6ab71a62"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0e2a07acbb5cd76c8b029de0e034a4f84bbafdfe3450b376269fd5dc6d8cb3b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ba4661c9eedfc06a2ac98145a0b240d913caca2dd73455cb20a2a4d65a82d32"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7bc8ab4bdbc09c1597eb7d32510b90535aa0e888b04d8e483405bc9ac10d1b85"
    sha256 cellar: :any,                 x86_64_linux:      "c08620eee37b739634c8418166540fa648d536d3a0f75652dd947593695a3122"
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
    output = shell_output("#{bin}/ktop --all-namespaces 2>&1", 1)
    assert_match "connection refused", output
  end
end
