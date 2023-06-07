class Finatra < Formula
  desc "Scala web framework inspired by Sinatra"
  homepage "http://finatra.info/"
  url "https://github.com/twitter/finatra/archive/1.5.3.tar.gz"
  sha256 "aa4fab5ccdc012da9edf4650addf54b6ba64eb7e6a5e88d8c76e68e4d89216de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4647f53656631f55bef9d4a4c3ef66adafa598c3e48a65be4199a1cdc33bf5dc"
  end

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"finatra"
  end

  test do
    system bin/"finatra"
  end
end
