class Gitsign < Formula
  desc "Keyless Git signing using Sigstore"
  homepage "https://github.com/sigstore/gitsign"
  url "https://github.com/sigstore/gitsign/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "646a86c2ff1786c2879b323304a1559c0b7f78913b9c825faa8612f6855be6b3"
  license "Apache-2.0"
  head "https://github.com/sigstore/gitsign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5538f1363f5de98c39e0852466e60760a1ac41897898a53ea8a1e6be8c51073"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5538f1363f5de98c39e0852466e60760a1ac41897898a53ea8a1e6be8c51073"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5538f1363f5de98c39e0852466e60760a1ac41897898a53ea8a1e6be8c51073"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5ccc30736a770121a38b5fb244366772e0896444327a77f2fd9e8603a45512e"
    sha256 cellar: :any_skip_relocation, ventura:       "b6fcf5ab28be0d59f6c3b190cfffccfb03e051f85134651e44e05346fa7724ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38e5d529b00b480c2a3563eb3b71c1f1e1bfaaa5494d179dbb10aca5f750600b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/sigstore/gitsign/pkg/version.gitVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gitsign", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsign --version")

    system "git", "clone", "https://github.com/sigstore/gitsign.git"
    cd testpath/"gitsign" do
      require "pty"
      stdout, _stdin, _pid = PTY.spawn("#{bin}/gitsign attest")
      assert_match "Generating ephemeral keys...", stdout.readline
    end
  end
end
