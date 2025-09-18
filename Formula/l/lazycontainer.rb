class Lazycontainer < Formula
  desc "Terminal UI for Apple Containers"
  homepage "https://github.com/andreybleme/lazycontainer"
  url "https://github.com/andreybleme/lazycontainer/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "c674297ccb1c3897865e4dd14d64ce7346f04f66430c125ad6c8bdfff0ba4228"
  license "MIT"
  head "https://github.com/andreybleme/lazycontainer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dc4071f1c199b099256ecbfae20165aefbeef9e9df7a0262d485f346039d13c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dc4071f1c199b099256ecbfae20165aefbeef9e9df7a0262d485f346039d13c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dc4071f1c199b099256ecbfae20165aefbeef9e9df7a0262d485f346039d13c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0dc4071f1c199b099256ecbfae20165aefbeef9e9df7a0262d485f346039d13c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ce2b590419deecde11f0a99a3cb3a22591ddc7a80a6074c867394baa7d8da66"
    sha256 cellar: :any_skip_relocation, ventura:       "9ce2b590419deecde11f0a99a3cb3a22591ddc7a80a6074c867394baa7d8da66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b396694656fa99e4ac1eae3d55e9d4976ba3c009afa3d248bdc63cd31345c5f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b28e111c6514af466fa079101c6b027f543f7c23193dd3c65056429c7e933122"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd"
  end

  test do
    require "pty"

    PTY.spawn(bin/"lazycontainer") do |r, _w, pid|
      out = r.readpartial(1024)
      assert_match "Error listing containers", out
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
