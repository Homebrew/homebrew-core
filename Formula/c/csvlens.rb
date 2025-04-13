class Csvlens < Formula
  desc "Command-line csv viewer"
  homepage "https://github.com/YS-L/csvlens"
  url "https://github.com/YS-L/csvlens/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "d95a3029e4ec471feb337f465e36910f712c790e629c8b23357d00b705399f6d"
  license "MIT"
  head "https://github.com/YS-L/csvlens.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed68dbcd995125c2b973101875f5eaba2a611e62db0d7bdf0ea1ad11c78bd5b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e7b44e6496caa54377eaf79872a5ac98735ef58b9c9d98b91e6c08851a6bdee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3596c058574d6df0ecae12a7376d6481c864de4123b148ac1e97f75ee1496163"
    sha256 cellar: :any_skip_relocation, sonoma:        "c147bab09ebdf31d9bc3e85bb19c55ef6640377363aeb1e0969d7b376c6b57e7"
    sha256 cellar: :any_skip_relocation, ventura:       "eee96abff43d55cc9c846799712d2aee6ac132dda2a3bbb47f91dfd8e9de5a33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b8d1df6d3ab2678c5d574764c3f774025a3a2e3771dc99b0af8241e148e6a57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f779201e350f658491b2326eeb7ff7b72155cb72b57310d707dc7ec3bc48bb5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"
    (testpath/"test.csv").write("A,B,C\n100,42,300")
    PTY.spawn(bin/"csvlens", "#{testpath}/test.csv", "--echo-column", "B") do |r, w, _pid|
      r.winsize = [10, 10]
      sleep 5
      # Select the column B by pressing enter. The answer 42 should be printed out.
      w.write "\r"
      assert r.read.end_with?("42\r\n")
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
