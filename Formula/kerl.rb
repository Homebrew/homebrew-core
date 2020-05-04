class Kerl < Formula
  desc "Easy building and installing of Erlang/OTP instances"
  homepage "https://github.com/kerl/kerl"
  url "https://github.com/kerl/kerl/archive/2.0.0.tar.gz"
  sha256 "76579a934d918e26731d7b0c7e2f41bb89512175b70886825ceb40f05110544f"
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
