class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.10.10.tar.gz"
  sha256 "dbef5afc118f54e794b539b86fc3a53ac4a94ec566ad78cddfe0580940388421"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "83f4c939a5772cf4a2f44418c51ad92e7b8f75b2ccf453a04a91f0ac5b978738" => :big_sur
    sha256 "cb93c449c3fc274b8aa934887d4118d975249c6230e8b99c0fd2e8cb85667f3f" => :catalina
    sha256 "aa475e4ad72a4fd7f73bcdf0e03e936d4d6dd4221bdfdf3dd28af0db0b2a26ce" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
