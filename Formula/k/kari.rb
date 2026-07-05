class Kari < Formula
  desc "Terminal-based media browser and streamer"
  homepage "https://github.com/Dhairya3391/kari"
  url "https://github.com/Dhairya3391/kari/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "6800cf5d7a4b4c68a2a58b72a7817c82ea1fd8c0d9efa7afbf5b012c29d4701b"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X kari/internal/app.Version=#{version}"), "./cmd/kari"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kari --version")
  end
end
