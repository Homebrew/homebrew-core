class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "93ff23276f2c626282037766542543dad5964fb6117c7902c4a4899607f8c95f"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "879a9dd160b78a585cc23800cfaa585931ecae474b0124444d102f6db1abc690"
    sha256 cellar: :any,                 arm64_big_sur:  "82ba393f5802e8c79799ba1ecade90d6d68744551e0941b36bef0aa6905ce398"
    sha256 cellar: :any,                 monterey:       "d6a2bda090dc8a6926240532cd03e2a38db9148bf8e4b93b5349eee4a516ae82"
    sha256 cellar: :any,                 big_sur:        "189cf039590bb7faeaa6953c0f1d87ee21e56bc8a4d3347431fc40132dfcafe3"
    sha256 cellar: :any,                 catalina:       "c13956c07d43794b803de27446371e0dcb070115146b44eb81095fb9d6b5edf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3acac9e6532c2775d0b83a22321e45cdb9a464df6848b12679641b5f1216a2d"
  end

  depends_on "coreutils" => :build
  depends_on "gcc"

  fails_with :clang # -ftree-loop-vectorize -flto=12 -s
  # GCC 10 at least is required
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with gcc: "8"
  fails_with gcc: "9"

  def install
    system "make", "CXX=#{ENV.cxx}", "STRIP=true"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    config = (testpath/".config/btop")
    mkdir config/"themes"
    (config/"btop.conf").write <<~EOS
      #? Config file for btop v. #{version}

      update_ms=2000
      log_level=DEBUG
    EOS

    require "pty"
    require "io/console"

    r, w, pid = PTY.spawn("#{bin}/btop")
    r.winsize = [80, 130]
    sleep 5
    w.write "q"

    log = (config/"btop.log").read
    assert_match "===> btop++ v.#{version}", log
    refute_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
