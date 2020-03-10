class Finatra < Formula
  desc "Scala web framework inspired by Sinatra"
  homepage "http://finatra.info/"
  url "https://github.com/twitter/finatra/archive/finatra-20.3.0.tar.gz"
  sha256 "6450dd809cfbace2b3057aa9e4c059a32fd0aa047f83a6a6c1de8a1f9f30d578"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"finatra"
  end

  test do
    system bin/"finatra"
  end
end
