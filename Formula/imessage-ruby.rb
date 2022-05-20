class ImessageRuby < Formula
  desc "Command-line tool to send iMessage"
  homepage "https://github.com/linjunpop/imessage"
  url "https://github.com/linjunpop/imessage/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "3d93570dd3ff000c51859aaa34c4a8e8b80b86e6bdf3018c1c7f6f8d85939b30"
  license "MIT"
  head "https://github.com/linjunpop/imessage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7c538ac24ec3ce437d868267582bd68aaa500eeb5a9bdbd3d0d80398b4bab19d"
  end

  depends_on :macos

  def install
    system "rake", "standalone:install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/imessage", "--version"
  end
end
