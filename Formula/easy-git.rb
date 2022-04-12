class EasyGit < Formula
  desc "Wrapper to simplify learning and using git"
  homepage "https://github.com/newren/easygit/"
  url "https://github.com/newren/easygit/archive/v1.8.5.tar.gz"
  sha256 "e2c6ac7fb390de1440a15808e5460b959bfb5000add11af91757ab61c48dead7"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d32fde25bfa6487f1ed7b4ca157b3d38cf64100b77d20c3ec35a0bf9b88894b9"
  end

  deprecate! date: "2022-04-12", because: :unmaintained

  def install
    bin.install "eg"
  end

  test do
    system "#{bin}/eg", "help"
  end
end
