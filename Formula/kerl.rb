class Kerl < Formula
  desc "Easy building and installing of Erlang/OTP instances"
  homepage "https://github.com/kerl/kerl"
  url "https://github.com/kerl/kerl/archive/2.2.2.tar.gz"
  sha256 "54c896ed694383cb09f0fa23c0d26c435c9ced3895424c6a7b5fed1c22eb9842"
  license "MIT"
  head "https://github.com/kerl/kerl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "78a778f5160edd54ee6734ebb8548748cee511946866e4b6ae0a4df39f63be2e"
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
