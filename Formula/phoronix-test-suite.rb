class PhoronixTestSuite < Formula
  desc "Open-source automated testing/benchmarking software"
  homepage "https://www.phoronix-test-suite.com/"
  url "https://github.com/phoronix-test-suite/phoronix-test-suite/archive/v10.8.1.tar.gz"
  sha256 "d17ab231a2dadec506624db62d560565ada065671b290dc460cb8a757e98d96e"
  license "GPL-3.0-or-later"
  head "https://github.com/phoronix-test-suite/phoronix-test-suite.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d890d3ab49f4d531c5a625126a06abb04891ca276ecf6748dae23be7f2893a62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d890d3ab49f4d531c5a625126a06abb04891ca276ecf6748dae23be7f2893a62"
    sha256 cellar: :any_skip_relocation, monterey:       "b0e93a748804846edbae06751c573a8909233df98385b9c94d2d0161a0b3c597"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0e93a748804846edbae06751c573a8909233df98385b9c94d2d0161a0b3c597"
    sha256 cellar: :any_skip_relocation, catalina:       "b0e93a748804846edbae06751c573a8909233df98385b9c94d2d0161a0b3c597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d890d3ab49f4d531c5a625126a06abb04891ca276ecf6748dae23be7f2893a62"
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
