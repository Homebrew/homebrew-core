class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.11.0.tar.gz"
  sha256 "2bf30335511d0bf0c89c693b108751ae8574f0ba757ff99d813969e959a90850"

  bottle do
    cellar :any_skip_relocation
    sha256 "611182aac3e9b302c52a9eef87a6ba55c8c85a265f2536e50c068b89a244284c" => :mojave
    sha256 "b30df8efbef0edb76b6d62403e8d9aafe1ea7ee1c3f1424fdd5ead66ca875e14" => :high_sierra
    sha256 "ef68b55b8b5e0b29fc72aca0a3665aa608fd6b9c76c99010805924ced6a6ce39" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"logs.txt").write("{\"key\": 5}")
    output = shell_output("#{bin}/agrind --file logs.txt '* | json'")
    assert_match "[key=5]", output
  end
end
