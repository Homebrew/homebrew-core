class Kerl < Formula
  desc "Easy building and installing of Erlang/OTP instances"
  homepage "https://github.com/kerl/kerl"
  url "https://github.com/kerl/kerl/archive/1.3.4.tar.gz"
  sha256 "9b60e9e40e63ea81f43a1e43a045c2130a3a2b129d6ec74e33229dc4d9933607"
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
