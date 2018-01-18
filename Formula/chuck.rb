class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "http://chuck.cs.princeton.edu/"
  url "http://chuck.cs.princeton.edu/release/files/chuck-1.3.6.0.tgz"
  mirror "https://dl.bintray.com/homebrew/mirror/chuck-1.3.6.0.tgz"
  sha256 "5a68b427c0caf63719a903c544244ddb67415889278f975234d58c7583ec34b4"

  bottle do
    cellar :any_skip_relocation
    sha256 "9bf0b727be8e8834dc9fa5f6f6e0ec2b03586a44156b6a8ed722ed9c92b8d041" => :high_sierra
    sha256 "baf8c0ba4a280b4541621fceeebf8a28c9b16bae69730487a2e794544a04f6fb" => :sierra
    sha256 "7c9c950c35def6347e37fa1455722312577e37efc5c83a9fb7f8d029ad88d033" => :el_capitan
  end

  depends_on :xcode => :build

  def install
    system "make", "-C", "src", "osx"
    bin.install "src/chuck"
    pkgshare.install "examples"
  end

  test do
    assert_match "device", shell_output("#{bin}/chuck --probe 2>&1")
  end
end
