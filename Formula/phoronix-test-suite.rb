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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "40c22f6775bbaa76dcca519e5ea051b0f358ed8327535170413fbd6355cee6e4"
    sha256 cellar: :any_skip_relocation, big_sur:       "df7663def4e0040411adf19b081d49382b464620c8aedcdb3e73dbc4f03a68dd"
    sha256 cellar: :any_skip_relocation, catalina:      "df7663def4e0040411adf19b081d49382b464620c8aedcdb3e73dbc4f03a68dd"
    sha256 cellar: :any_skip_relocation, mojave:        "df7663def4e0040411adf19b081d49382b464620c8aedcdb3e73dbc4f03a68dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40c22f6775bbaa76dcca519e5ea051b0f358ed8327535170413fbd6355cee6e4"
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
