class Nerdfetch < Formula
  desc "POSIX *nix fetch script using Nerdfonts"
  homepage "https://github.com/ThatOneCalculator/NerdFetch"
  url "https://github.com/ThatOneCalculator/NerdFetch/archive/refs/tags/v8.4.2.tar.gz"
  sha256 "cad765074e4b3f442bf78813f690343d58d3dfd42c90ab83bf93d101f890b27e"
  license "MIT"
  head "https://github.com/ThatOneCalculator/NerdFetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e441ddc3a3129b74f1b924c3740411667addf14ee01339d2d38f63fb1e4b25a0"
  end

  def install
    bin.install "nerdfetch"
  end

  test do
    user = ENV["USER"]
    assert_match user.to_s, shell_output(bin/"nerdfetch")
  end
end
