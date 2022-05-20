class Kerl < Formula
  desc "Easy building and installing of Erlang/OTP instances"
  homepage "https://github.com/kerl/kerl"
  url "https://github.com/kerl/kerl/archive/2.4.0.tar.gz"
  sha256 "f6fd684fb6682e901cfc54c5834cc3bf24811ccf29ae97c0a7e1f2d2be66975b"
  license "MIT"
  head "https://github.com/kerl/kerl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d2307a33891bcca81d40c51a2994c4c6b13a29b430bdf7091cc727386ef9ca13"
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
