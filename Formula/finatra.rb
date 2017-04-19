class Finatra < Formula
  desc "Scala web framework inspired by Sinatra"
  homepage "http://finatra.info/"
  url "https://github.com/twitter/finatra/archive/finatra-2.1.6.tar.gz"
  sha256 "0969e898ae31ce3c28922146b6b44a5910b54b498b697c56727e26960b7a6cd5"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"finatra"
  end

  test do
    system bin/"finatra"
  end
end
