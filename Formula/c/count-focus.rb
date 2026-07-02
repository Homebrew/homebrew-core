class CountFocus < Formula
  desc "Focus timer for the terminal"
  homepage "https://github.com/gianni-labs/count-focus"
  url "https://github.com/gianni-labs/count-focus/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "22c6dc4c177826cb004cef3dc506bd273becc5f5810d1c0ce482d71ebaf59a10"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "count-focus <duration>", shell_output("#{bin}/count-focus --help")
  end
end
