class Kerl < Formula
  desc "Easy building and installing of Erlang/OTP instances"
  homepage "https://github.com/kerl/kerl"
  url "https://github.com/kerl/kerl/archive/2.5.1.tar.gz"
  sha256 "609e73387808a06837d2c53649902f1b04c14a34b4a7af34ad5d44cef6314ff3"
  license "MIT"
  head "https://github.com/kerl/kerl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7d404cee785f8b5b8b122516ad42fa8f0a79c9443cf9691aacecd25494bb1b72"
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
