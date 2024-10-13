class Modgit < Formula
  desc "Tool for git repo deploy with filters. Used for magento development"
  homepage "https://github.com/jreinke/modgit"
  url "https://github.com/jreinke/modgit/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "9d279c370eee29f54017ca20cf543efda87534bd6a584e7c0f489bbf931dccb8"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "5d74396c99246d4279d33abfaa9c4ca5671be43bb9f174b487f0d7cff0334f8c"
  end

  disable! date: "2024-08-10", because: :no_license

  def install
    bin.install "modgit"
  end

  test do
    system bin/"modgit"
  end
end
