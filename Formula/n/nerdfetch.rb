class Nerdfetch < Formula
  desc "POSIX *nix fetch script using Nerdfonts"
  homepage "https://github.com/ThatOneCalculator/NerdFetch"
  url "https://github.com/ThatOneCalculator/NerdFetch/archive/refs/tags/v8.5.5.tar.gz"
  sha256 "944b08b957a82386fa3f394ef733e31f7208acee0681c6000d5cd042c16813d6"
  license "MIT"
  head "https://github.com/ThatOneCalculator/NerdFetch.git", branch: "main"

  bottle do
    manifest_sha256 "25d9e660b3613934f51c60780c89ef50ef5c8795e0204938a39bf960cadca00f"
    sha256 cellar: :any_skip_relocation, all: "ddb0aba42fb7367b693e68ff5fd47a65d5a1c02324e858cf99aea5061d7b1cf4"
  end

  def install
    bin.install "nerdfetch"
  end

  test do
    user = ENV["USER"]
    assert_match user.to_s, shell_output(bin/"nerdfetch")
  end
end
