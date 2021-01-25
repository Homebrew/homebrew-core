class Icon < Formula
  desc "General-purpose programming language"
  homepage "https://www.cs.arizona.edu/icon/"
  url "https://github.com/gtownsend/icon/archive/v9.5.20i.tar.gz"
  version "9.5.20i"
  sha256 "3ebfcc89f3f3f7acc5afe61402f6b3b168b8cd83f79021c98bbd791e92c4cbe8"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "14023318a41cfb25dc16580def3078398493ed67a6c17bcf4fef748ef8bf2779" => :big_sur
    sha256 "1d414ead849c9d0c8f20fdbba672c2ffc0cc32d3522cb8bf3aa0dc20324ac875" => :arm64_big_sur
    sha256 "fc52931ec8205d4bce4a9d7b2d8d8a12bcca9c55ac3e0fa8a1c1e5550f193ccc" => :catalina
    sha256 "7375228280ad4b34aa3e703da54e6af031c78c644636f1e1e45f0b776b4f5b18" => :mojave
  end

  def install
    ENV.deparallelize
    system "make", "Configure", "name=posix"
    system "make"
    bin.install "bin/icon", "bin/icont", "bin/iconx"
    doc.install Dir["doc/*"]
    man1.install Dir["man/man1/*.1"]
  end

  test do
    args = "'procedure main(); writes(\"Hello, World!\"); end'"
    output = shell_output("#{bin}/icon -P #{args}")
    assert_equal "Hello, World!", output
  end
end
