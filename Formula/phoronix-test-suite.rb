class PhoronixTestSuite < Formula
  desc "Open-source automated testing/benchmarking software"
  homepage "https://www.phoronix-test-suite.com/"
  url "https://github.com/phoronix-test-suite/phoronix-test-suite/archive/v10.8.3.tar.gz"
  sha256 "752012b6e94897f03a219157fe1ba6c4198eb16a5ddf026811b739f1f89cfd9e"
  license "GPL-3.0-or-later"
  head "https://github.com/phoronix-test-suite/phoronix-test-suite.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3ef1554e954d39cbcbed7d749e4250bb94d0c71b0c3f8777ee43e0e9e05e4b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3ef1554e954d39cbcbed7d749e4250bb94d0c71b0c3f8777ee43e0e9e05e4b1"
    sha256 cellar: :any_skip_relocation, monterey:       "69aa498eda75a3f1706ab0ed9cc33ba18060b19bbb56824b8dfc981d0fda5641"
    sha256 cellar: :any_skip_relocation, big_sur:        "69aa498eda75a3f1706ab0ed9cc33ba18060b19bbb56824b8dfc981d0fda5641"
    sha256 cellar: :any_skip_relocation, catalina:       "69aa498eda75a3f1706ab0ed9cc33ba18060b19bbb56824b8dfc981d0fda5641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3ef1554e954d39cbcbed7d749e4250bb94d0c71b0c3f8777ee43e0e9e05e4b1"
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
