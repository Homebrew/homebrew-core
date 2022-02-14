class PhoronixTestSuite < Formula
  desc "Open-source automated testing/benchmarking software"
  homepage "https://www.phoronix-test-suite.com/"
  url "https://github.com/phoronix-test-suite/phoronix-test-suite/archive/v10.8.2.tar.gz"
  sha256 "804ff2de03166241768d2b35584aee2820a7b84dda9f697f12ab5d454f7e5624"
  license "GPL-3.0-or-later"
  head "https://github.com/phoronix-test-suite/phoronix-test-suite.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8c478db420caad8a285558c6e95e08205463d3751911d43f43885ae2ce4acb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8c478db420caad8a285558c6e95e08205463d3751911d43f43885ae2ce4acb7"
    sha256 cellar: :any_skip_relocation, monterey:       "c2327daae03c6ef3b8e8c69eee1e6121bf748e34db82f54d303399ee5ddc59d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2327daae03c6ef3b8e8c69eee1e6121bf748e34db82f54d303399ee5ddc59d1"
    sha256 cellar: :any_skip_relocation, catalina:       "c2327daae03c6ef3b8e8c69eee1e6121bf748e34db82f54d303399ee5ddc59d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8c478db420caad8a285558c6e95e08205463d3751911d43f43885ae2ce4acb7"
  end

  depends_on "php"

  def install
    ENV["DESTDIR"] = buildpath/"dest"
    system "./install-sh", prefix
    prefix.install (buildpath/"dest/#{prefix}").children
    bash_completion.install "dest/#{prefix}/../etc/bash_completion.d/phoronix-test-suite"
  end

  # 7.4.0 installed files in the formula's rack so clean up the mess.
  def post_install
    rm_rf [prefix/"../etc", prefix/"../usr"]
  end

  test do
    cd pkgshare if OS.mac?

    # Work around issue directly running command on Linux CI by using spawn.
    # Error is "Forked child process failed: pid ##### SIGKILL"
    require "pty"
    output = ""
    PTY.spawn(bin/"phoronix-test-suite", "version") do |r, _w, pid|
      sleep 2
      Process.kill "TERM", pid
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    assert_match version.to_s, output
  end
end
