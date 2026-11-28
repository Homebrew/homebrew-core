class Gist < Formula
  desc "Command-line utility for uploading Gists"
  homepage "https://defunkt.io/gist/"
  url "https://github.com/defunkt/gist/archive/refs/tags/v6.1.0.tar.gz"
  sha256 "53c72eb07bcdd71b1a8fdd3f81a3cc44a332b92c34a30632e45d6941c10f3096"
  license "MIT"
  head "https://github.com/defunkt/gist.git", branch: "master"

  bottle do
    manifest_sha256 "e5dc3855aa3f8f89877fbaaed51529a1f4aa3a8792d1921fb9359c4b2e794af6"
    sha256 cellar: :any_skip_relocation, all: "d3596bb6c1e1c112cd0276a220a4ff7a6a40d45be3a5c0c6cff8faf9ed69ae6b"
  end

  uses_from_macos "ruby"

  def install
    system "rake", "install", "prefix=#{prefix}"
  end

  test do
    output = pipe_output(bin/"gist", "homebrew")
    assert_match "GitHub now requires credentials", output
  end
end
