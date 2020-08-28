class Gist < Formula
  desc "Command-line utility for uploading Gists"
  homepage "https://github.com/defunkt/gist"
  url "https://github.com/defunkt/gist/archive/v6.0.0.tar.gz"
  sha256 "ddfb33c039f8825506830448a658aa22685fc0c25dbe6d0240490982c4721812"
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
