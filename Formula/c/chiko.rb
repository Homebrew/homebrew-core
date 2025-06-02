class Chiko < Formula
  desc "Ultimate Beauty gRPC Client for your Terminal"
  homepage "https://github.com/felangga/chiko"
  url "https://github.com/felangga/chiko/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "054151d8c8c05ff2ccf0283328221b8143ea17146ef4dde4d63d7f1d31b11748"
  license "MIT"
  head "https://github.com/felangga/chiko.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2229abf255f4cf1d7edceeb7cbb7716cec4b20481961a1763d89396400df9fa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2229abf255f4cf1d7edceeb7cbb7716cec4b20481961a1763d89396400df9fa9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2229abf255f4cf1d7edceeb7cbb7716cec4b20481961a1763d89396400df9fa9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f4b24bea33c35b4030520703ed9342b359e88f33812f405104ec7013ed8bce4"
    sha256 cellar: :any_skip_relocation, ventura:       "6f4b24bea33c35b4030520703ed9342b359e88f33812f405104ec7013ed8bce4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40b295024b26e9f4d4542a88f7ef38f99c7620f1e4efd0ba734d962ff19bf8b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d6db73f2ae1ae61da75af4e9678b15709a6bafa752f46655e7bf7d4702d4e02"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/chiko"
  end

  test do
    ENV["TERM"] = "xterm"
    require "pty"

    PTY.spawn(bin/"chiko") do |r, w, _pid|
      w.write "q"
      assert_match "The Ultimate Beauty GRPC Client", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
