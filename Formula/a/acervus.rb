class Acervus < Formula
  desc "CLI tool for interacting with Acervus Cloud"
  homepage "https://github.com/paribu/acervus-cli"
  url "https://github.com/paribu/acervus-cli/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "d02a6465aed995f4a18b289d7e16f203dd875cc2bd9db5ad2572bfd68754d175"
  head "https://github.com/paribu/acervus-cli.git", branch: "main"

  depends_on "go@1.20" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "acervus version 0.0.1", shell_output("#{bin}/acervus --version")
  end
end
