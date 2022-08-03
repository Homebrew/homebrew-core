class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https://github.com/danobi/prr"
  url "https://github.com/danobi/prr/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "becebd6746b62380ff354e0d4e92b515c0aac719e9d504f33b6d9321b2d80853"
  license "GPL-2.0-only"
  head "https://github.com/danobi/prr.git", branch: "master"

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Failed to read config", shell_output("#{bin}/prr get Homebrew/homebrew-core/6 2>&1", 1)
  end
end
