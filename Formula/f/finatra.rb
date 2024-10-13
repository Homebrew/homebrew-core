class Finatra < Formula
  desc "Scala web framework inspired by Sinatra"
  homepage "http://finatra.info/"
  url "https://github.com/twitter/finatra/archive/refs/tags/1.5.3.tar.gz"
  sha256 "aa4fab5ccdc012da9edf4650addf54b6ba64eb7e6a5e88d8c76e68e4d89216de"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "adbf00cd007ff84e48376228209f6ad7f73d34dea489cfe762267ab42d0252d1"
  end

  disable! date: "2024-09-09", because: "library with minimal downloads"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"finatra"
  end

  test do
    system bin/"finatra"
  end
end
