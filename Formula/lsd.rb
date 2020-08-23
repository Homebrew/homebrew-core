class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.17.0.tar.gz"
  sha256 "65b03ae322c4d3ed47f502866b4da2b2c7029b6cb5dc989e98664d564a57de1d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7522117f464233363dc65128ba98dd51863e86acab321326c687a0fe8a7e2541" => :catalina
    sha256 "a53f4d8e3bbfdbd9382fc17e770a1a050efd020bd92d84fcfe17542df42af785" => :mojave
    sha256 "9ee5f02f84c89b1c430339831f7de094dbb38874cb47f6832b23e2b30c2af2d9" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
