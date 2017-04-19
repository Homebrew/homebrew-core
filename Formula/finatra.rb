class Finatra < Formula
  desc "Scala web framework inspired by Sinatra"
  homepage "http://finatra.info/"
  url "https://github.com/twitter/finatra/archive/finatra-2.2.0.tar.gz"
  sha256 "a3fa441ac65303f0ac05a821c2644b9bacbf7cc916fd0cee4bbb6273296693e8"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"finatra"
  end

  test do
    system bin/"finatra"
  end
end
