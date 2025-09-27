class Httptap < Formula
  desc "View HTTP/HTTPS requests made by any Linux program"
  homepage "https://github.com/monasticacademy/httptap"
  url "https://github.com/monasticacademy/httptap/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "dc6b99f20b1ab33f6801050a2367529a235c2b1a654d24f908b1f1bf62a36457"
  license "MIT"
  head "https://github.com/monasticacademy/httptap.git", branch: "main"

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/httptap -- curl -s https://httpbin.org -o /dev/null")
    assert_match "<--- 200 https://httpbin.org/", output
  end
end
