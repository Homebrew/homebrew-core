class Gist < Formula
  desc "Command-line utility for uploading Gists"
  homepage "https://github.com/defunkt/gist"
  url "https://github.com/defunkt/gist/archive/v5.0.0.tar.gz"
  sha256 "28a3ebaad90ede9a59bd4dbe4850a07cc6e3294a92849a0f0b17ebf6a17ea33b"
  head "https://github.com/defunkt/gist.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a92937549e26ba5bbb9059c9f97de66f6cc87c09906a7a52e0946a8634153328" => :high_sierra
    sha256 "384be8756092732a7bf082b0208f9a1634605e7d1ba873d5a6600180e228890c" => :sierra
    sha256 "384be8756092732a7bf082b0208f9a1634605e7d1ba873d5a6600180e228890c" => :el_capitan
  end

  depends_on "ruby" if MacOS.version <= :sierra

  def install
    system "rake", "install", "prefix=#{prefix}"
  end

  test do
    output = pipe_output("#{bin}/gist", "homebrew")
    assert_match "Github now requires credentials", output
  end
end
