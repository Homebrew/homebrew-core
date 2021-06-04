class EasyGit < Formula
  desc "Wrapper to simplify learning and using git"
  homepage "https://people.gnome.org/~newren/eg/"
  url "https://people.gnome.org/~newren/eg/download/1.7.5.2/eg"
  sha256 "59bb4f8b267261ab3d48c66b957af851d1a61126589173ebcc20ba9f43c382fb"

  livecheck do
    url "https://people.gnome.org/~newren/eg/download/"
    regex(%r{href=.*?(\d+(?:\.\d+)+)/eg["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d32fde25bfa6487f1ed7b4ca157b3d38cf64100b77d20c3ec35a0bf9b88894b9"
  end

  def install
    bin.install "eg"
  end

  test do
    system "#{bin}/eg", "help"
  end
end
