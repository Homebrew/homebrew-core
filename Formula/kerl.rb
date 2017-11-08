class Kerl < Formula
  desc "Easy building and installing of Erlang/OTP instances"
  homepage "https://github.com/kerl/kerl"
  url "https://github.com/kerl/kerl/archive/1.8.0.tar.gz"
  sha256 "ec7704efb39a78be41eaeac0ae39b572f13359f0cdd2201f68a2e7db600a8321"
  head "https://github.com/kerl/kerl.git"

  bottle :unneeded

  def install
    bin.install "kerl"
    bash_completion.install "bash_completion/kerl"
    zsh_completion.install "zsh_completion/_kerl"
  end

  test do
    system "#{bin}/kerl", "list", "releases"
  end
end
