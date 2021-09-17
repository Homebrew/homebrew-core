class Kerl < Formula
  desc "Easy building and installing of Erlang/OTP instances"
  homepage "https://github.com/kerl/kerl"
  url "https://github.com/kerl/kerl/archive/2.2.0.tar.gz"
  sha256 "fbd690e207c4249e752d801d9ce2b2c5e3c45ff51293eb73ffeb642b8dcfe0d5"
  license "MIT"
  head "https://github.com/kerl/kerl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ff7a18c24da7d338e817534fb22fd60a797e5472795531a4605f706a51517771"
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
