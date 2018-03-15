class Kerl < Formula
  desc "Easy building and installing of Erlang/OTP instances"
  homepage "https://github.com/kerl/kerl"
  url "https://github.com/kerl/kerl/archive/1.8.2.tar.gz"
  sha256 "70aba26e75f217cd47f86702018ec66efcc3a6092e60f21bfadf01394325ba7d"
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
