class ImessageRuby < Formula
  desc "Command-line tool to send iMessage"
  homepage "https://github.com/linjunpop/imessage"
  url "https://github.com/linjunpop/imessage/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "e5f1f69f0a21914cff3ea27d7b804295be6b2cebd2b5b28c47cb25a7b98028b5"
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
