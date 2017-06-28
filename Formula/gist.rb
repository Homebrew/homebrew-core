class Gist < Formula
  desc "Command-line utility for uploading Gists"
  homepage "https://github.com/defunkt/gist"
  url "https://github.com/defunkt/gist/archive/v4.6.1.tar.gz"
  sha256 "8438793d39655405ee565d80d361553f9e485e684f361f74b6e199ac93ac2fed"
  head "https://github.com/defunkt/gist.git"

  bottle do
    cellar :any_skip_relocation
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
