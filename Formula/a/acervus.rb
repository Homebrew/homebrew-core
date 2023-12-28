class Acervus < Formula
  desc "CLI tool for interacting with Acervus Cloud"
  homepage "https://github.com/paribu/acervus-cli"
  url "https://github.com/paribu/acervus-cli/archive/refs/tags/v0.0.1.tar.gz"
  head "https://github.com/paribu/acervus-cli.git", branch: "main"

  depends_on "go@1.20" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end
end
