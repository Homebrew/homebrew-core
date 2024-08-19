class Kerl < Formula
  desc "Easy building and installing of Erlang/OTP instances"
  homepage "https://github.com/kerl/kerl"
  url "https://github.com/kerl/kerl/archive/refs/tags/4.2.0.tar.gz"
  sha256 "a9306ad72d1d94d5e2592689cf54997e2481bd16813ed6eb4f8ed4f83f595ad4"
  license "MIT"
  head "https://github.com/kerl/kerl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "68b0f3b236587140f018793ba4ed38114e3a3241b326e3afe98ef174a8471372"
  end

  def install
    bin.install "kerl"

    bash_completion.install "bash_completion/kerl"
    zsh_completion.install "zsh_completion/_kerl"
  end

  test do
    system bin/"kerl", "list", "releases"
  end
end
