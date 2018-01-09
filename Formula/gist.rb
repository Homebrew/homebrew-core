class Gist < Formula
  desc "Command-line utility for uploading Gists"
  homepage "https://github.com/defunkt/gist"
  url "https://github.com/defunkt/gist/archive/v4.6.2.tar.gz"
  sha256 "149a57ba7e8a8751d6a55dc652ce3cf0af28580f142f2adb97d1ceeccb8df3ad"
  head "https://github.com/defunkt/gist.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b72c20d3739cf7f21c0535d053e91944ad2e0178771bab2043321cb6553677b2" => :high_sierra
    sha256 "451aefde9237d4bcf8eacbb3dba1bc4a0d810e8d42a54d2d3731bf7a8e380d3c" => :sierra
    sha256 "47fea39a7e01db2b2ee032bbdf68d1d714fa1fa4aa7ed2b578ba86fd7151f555" => :el_capitan
    sha256 "47fea39a7e01db2b2ee032bbdf68d1d714fa1fa4aa7ed2b578ba86fd7151f555" => :yosemite
  end

  def install
    rake "install", "prefix=#{prefix}"
  end

  test do
    assert_match %r{https:\/\/gist}, pipe_output("#{bin}/gist", "homebrew")
  end
end
