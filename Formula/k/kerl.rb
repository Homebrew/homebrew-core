class Kerl < Formula
  desc "Easy building and installing of Erlang/OTP instances"
  homepage "https://github.com/kerl/kerl"
  url "https://github.com/kerl/kerl/archive/4.0.0.tar.gz"
  sha256 "5731a6d2292aab9e90c83d12a50c064079467126dc335eba6b8654c0306568d1"
  license "MIT"
  head "https://github.com/kerl/kerl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8b5467bdcc5df239257cd18fb5f7e6fa01457b9ba86b77cea04898033e564075"
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
