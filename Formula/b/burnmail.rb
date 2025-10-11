class Burnmail < Formula
  desc "A simple CLI tool to generate and manage temporary email addresses with TUI"
  homepage "https://github.com/fraluc06/burnmail"
  url "https://github.com/fraluc06/burnmail/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "aee5434160f29b034994644d2e57b3da951d5fb11b25949dca59148269b5c513"
  license "MIT"
  head "https://github.com/fraluc06/burnmail.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "."
  end

  test do
    output = shell_output("#{bin}/burnmail --version")
    assert_match version.to_s, output

    output = shell_output("#{bin}/burnmail domains 2>&1")
    assert_match "Available domains", output
  end
end
