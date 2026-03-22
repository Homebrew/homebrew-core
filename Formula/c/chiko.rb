class Chiko < Formula
  desc "Ultimate Beauty gRPC Client for your Terminal"
  homepage "https://github.com/felangga/chiko"
  url "https://github.com/felangga/chiko/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "b43b03caf132c0a4455176ee913829fae81fb55d4826848512b391944a36192a"
  license "MIT"
  head "https://github.com/felangga/chiko.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6ec5af4743aea0cead12147f1a4ec3250f673665ec83ff41e248c44e65b5d9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6ec5af4743aea0cead12147f1a4ec3250f673665ec83ff41e248c44e65b5d9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6ec5af4743aea0cead12147f1a4ec3250f673665ec83ff41e248c44e65b5d9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bc264aa5d22ec43adc42bc5d4d8c67a3e3f6369e81d0029ebe0467e3805fc36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f67b687559e8d246e9c1f33654ebc0e53b9d0d04bbf3c40c538c01c337fd1279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b832793daa47297015be5e2b70a64c44c9affb91a168045896905f747bb0b1d"
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
