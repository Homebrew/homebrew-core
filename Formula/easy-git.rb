class EasyGit < Formula
  desc "Wrapper to simplify learning and using git"
  homepage "https://github.com/newren/easygit/"
  url "https://github.com/newren/easygit/archive/v1.8.5.tar.gz"
  sha256 "e2c6ac7fb390de1440a15808e5460b959bfb5000add11af91757ab61c48dead7"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4f1bd257689c7102a91799fdb7ca4a1e64638aa08ec1dad92070c875e6021a04"
  end

  deprecate! date: "2022-04-12", because: :unmaintained

  def install
    bin.install "eg"
  end

  test do
    system "#{bin}/eg", "help"
  end
end
