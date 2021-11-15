class PhoronixTestSuite < Formula
  desc "Open-source automated testing/benchmarking software"
  homepage "https://www.phoronix-test-suite.com/"
  url "https://github.com/phoronix-test-suite/phoronix-test-suite/archive/v10.6.1.tar.gz"
  sha256 "136d875a7ad9ec97b437638694fc25818b9262c90017c317d7a16c2255a9492f"
  license "GPL-3.0-or-later"
  head "https://github.com/phoronix-test-suite/phoronix-test-suite.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8249f2433189e0cbec8679cdb7e8409dc6de43529fe578aefa7d1e7c7d6d527"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8249f2433189e0cbec8679cdb7e8409dc6de43529fe578aefa7d1e7c7d6d527"
    sha256 cellar: :any_skip_relocation, monterey:       "283b346e8aa480700b3242aadfefa53f25a935ec27cc745540a8aee1e5526a0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "283b346e8aa480700b3242aadfefa53f25a935ec27cc745540a8aee1e5526a0f"
    sha256 cellar: :any_skip_relocation, catalina:       "283b346e8aa480700b3242aadfefa53f25a935ec27cc745540a8aee1e5526a0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8249f2433189e0cbec8679cdb7e8409dc6de43529fe578aefa7d1e7c7d6d527"
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
