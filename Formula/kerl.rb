class Kerl < Formula
  desc "Easy building and installing of Erlang/OTP instances"
  homepage "https://github.com/kerl/kerl"
  url "https://github.com/kerl/kerl/archive/1.3.1.tar.gz"
  sha256 "8c99021012f50f8656e1eaaf26cee5aa522b19c1f8eb58cb572a712fa2ad5cde"
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
