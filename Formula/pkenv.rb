class Pkenv < Formula
  desc "Packer version manager mainly inspired by tfenv"
  homepage "https://github.com/iamhsa/pkenv"
  url "https://github.com/iamhsa/pkenv/archive/0.3.0.tar.gz"
  sha256 "f226b96fb17482be76dc54d031b05a9e9a566d9c2674851d388adecc21d99c6a"
  head "https://github.com/iamhsa/pkenv.git"

  bottle :unneeded

  conflicts_with "packer", :because => "pkenv symlinks Packer binaries"

  def install
    prefix.install ["bin", "libexec"]
  end

  test do
    system "bin/tfenv", "list-remote"
  end
end
