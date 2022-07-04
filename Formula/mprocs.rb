class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https://github.com/pvolok/mprocs"
  url "https://github.com/pvolok/mprocs/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "c9314e81b0a5584e73a1afc2c1b5b83df0ed31213992447324cb95abbda618ce"
  license "MIT"
  head "https://github.com/pvolok/mprocs.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mprocs --version")
  end
end
