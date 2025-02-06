class Chiko < Formula
  desc "Ultimate Beauty gRPC Client for your Terminal"
  homepage "https://github.com/felangga/chiko"
  url "https://github.com/felangga/chiko/archive/refs/tags/v0.0.5.tar.gz"
  sha256 "de0df67604c243be104236d562899a3e18c041297b8d4a658c042c0ccc901332"
  license "MIT"
  head "https://github.com/felangga/chiko.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56efedda7eb1b8077245451134fbebb015e36915bf5b821df13e3f17d91e39d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56efedda7eb1b8077245451134fbebb015e36915bf5b821df13e3f17d91e39d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56efedda7eb1b8077245451134fbebb015e36915bf5b821df13e3f17d91e39d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0fec974cc0e42f8c102c07b9afbba41b02fca453f67638ea08ab38136f955c1"
    sha256 cellar: :any_skip_relocation, ventura:       "d0fec974cc0e42f8c102c07b9afbba41b02fca453f67638ea08ab38136f955c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a090ba84fa12454b6d5e516b076b04237676cf4ff7a72f2c8925e7ecbe55665"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
