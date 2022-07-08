class Minigun < Formula
  desc "Simple HTTP benchmark tool"
  homepage "https://github.com/wayfair-incubator/minigun"
  url "https://github.com/wayfair-incubator/minigun/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "19e01b9126b0b7f5317ea339d6e356951bf8eb46b63579c2133673f5faaa8573"
  license "MIT"
  head "https://github.com/wayfair-incubator/minigun.git", branch: "main"

  depends_on "go@1.17" => :build

  def install
    system "#{Formula["go@1.17"].opt_bin}/go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "Version: #{version}", shell_output("#{bin}/minigun -version").strip

    minigun_test_params = [
      "-fire-target http://localhost:45678",
      "-fire-duration 1s",
      "-fire-rate 1",
      "-report json",
    ]
    assert_match "http://localhost:45678",
      shell_output("#{bin}/minigun #{minigun_test_params.join " "} 2>/dev/null").strip
  end
end
