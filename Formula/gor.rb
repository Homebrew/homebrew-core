class Gor < Formula
  desc "Real-time HTTP traffic replay tool written in Go"
  homepage "https://gortool.com"
  url "https://github.com/buger/goreplay.git",
    :tag      => "v1.1.0",
    :revision => "5cbb5ea85fcb33c40b314d8baf84cac65a623098"
  license "LGPL-3.0"
  head "https://github.com/buger/goreplay.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a36b70bcd45188693395cea5faec7fbc59641f2aac7918e16042560064d28ad0" => :catalina
    sha256 "ad78a27ea91f8731573e633bcb3490a62fb8d1330292544da37876fb8d8805a5" => :mojave
    sha256 "b8c6106bc0ef1b1defc163d9e3e477a8d0462ab65b9b3f409a8a79debf96ba85" => :high_sierra
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=#{version}", *std_go_args
  end

  test do
    test_port = free_port
    fork do
      exec bin/"gor", "file-server", ":#{test_port}"
    end

    sleep 2
    system "nc", "-z", "localhost", test_port
  end
end
