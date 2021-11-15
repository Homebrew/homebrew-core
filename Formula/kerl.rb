class Kerl < Formula
  desc "Easy building and installing of Erlang/OTP instances"
  homepage "https://github.com/kerl/kerl"
  url "https://github.com/kerl/kerl/archive/2.2.2.tar.gz"
  sha256 "54c896ed694383cb09f0fa23c0d26c435c9ced3895424c6a7b5fed1c22eb9842"
  license "MIT"
  head "https://github.com/kerl/kerl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "33646c2f97a3dcd62521b92dc91eff01c2e4a6e18fd9b28f2db4edb2c27b408a"
  end

  def install
    bin.install "kerl"
    bash_completion.install "bash_completion/kerl"
    zsh_completion.install "zsh_completion/_kerl"
  end

  test do
    system "#{bin}/kerl", "list", "releases"
  end
end
