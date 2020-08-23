class Gist < Formula
  desc "Command-line utility for uploading Gists"
  homepage "https://github.com/defunkt/gist"
  url "https://github.com/defunkt/gist/archive/v5.1.0.tar.gz"
  sha256 "843cea035c137d23d786965688afc9ee70610ac6c3d6f6615cb958d6c792fbb2"
  license "MIT"
  head "https://github.com/defunkt/gist.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7eb37c0514203306a3e5be9176acca230014a30e07d43d0e9ba72afcc3dc3203" => :catalina
    sha256 "7eb37c0514203306a3e5be9176acca230014a30e07d43d0e9ba72afcc3dc3203" => :mojave
    sha256 "7eb37c0514203306a3e5be9176acca230014a30e07d43d0e9ba72afcc3dc3203" => :high_sierra
  end

  depends_on "ruby" if MacOS.version <= :sierra

  def install
    system "rake", "install", "prefix=#{prefix}"
  end

  test do
    output = pipe_output("#{bin}/gist", "homebrew")
    assert_match "GitHub now requires credentials", output
  end
end
