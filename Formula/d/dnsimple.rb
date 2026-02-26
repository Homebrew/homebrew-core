class Dnsimple < Formula
  desc "Terminal-first DNSimple client (TUI + CLI)"
  homepage "https://github.com/dorkitude/simple"
  url "https://github.com/dorkitude/simple/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "b7815c6c941699d33997b0d91f7a5e436dfb2890af7cf9504a1d5ec58c14d95a"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dnsimple"), "."
    bin.install_symlink "dnsimple" => "simple"
    bin.install_symlink "dnsimple" => "dnsimplectl"
  end

  test do
    assert_match "DNSimple", shell_output("#{bin}/dnsimple --help")
  end
end
