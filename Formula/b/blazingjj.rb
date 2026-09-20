class Blazingjj < Formula
  desc "TUI for Jujutsu/jj"
  homepage "https://github.com/blazingjj/blazingjj"
  url "https://github.com/blazingjj/blazingjj/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "e32060dd7e74339df4fac48254835443509aea3a10b59cade39ed787bbbf878d"
  license "Apache-2.0"

  depends_on "rust" => :build
  depends_on "jj"

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["BLAZINGJJ_LOG"] = "1"

    assert_match version.to_s, shell_output("#{bin}/blazingjj --version")

    output = shell_output("#{bin}/blazingjj 2>&1", 1)
    assert_match "Error: No jj repository found", output
    assert_path_exists testpath/"blazingjj.log"
  end
end
