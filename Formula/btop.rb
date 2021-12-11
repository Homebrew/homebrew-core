class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "c50c2278b398094b394dec034abb9c77b85eb7e8e9ec83df6f03ea85454d2aba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "68e5a9443d0d0c1774d85a89ca3d3df40047cf0b8744fec7f9dc434c7d5e9481"
    sha256 cellar: :any,                 arm64_big_sur:  "365263da5a8c7918a2ff86c67ea40aa15fcea93ddbae9bfd801621ada42bef19"
    sha256 cellar: :any,                 monterey:       "0a5cf31a1ecead5b1b96d38e9cfbde21f8c34378cf7902bafed48a30018d33be"
    sha256 cellar: :any,                 big_sur:        "66a045df8653859b068eeb8ea34be3561fb3367ca459ea7fa499cc614631e6fc"
    sha256 cellar: :any,                 catalina:       "1a5401de3bdf14498e72dc6a0536863b8e3e9268a213079e8bce082cd725ad02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70da8dc40274e2babe7cc6805c39ab972b3f34baf4f211161983eda01f5a80ba"
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
