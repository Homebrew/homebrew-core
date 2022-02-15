class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "9e16b76ad74086948fa3dce4899a5532095a1656e6f1deec3e807f992d22f47c"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "46074c691986b47dd7ec54e152b59c7cb8c69204744ce4f637130f0aba437f04"
    sha256 cellar: :any,                 arm64_big_sur:  "30f32ee8819237bec41e3bb321f859228e585fdeb963fbb555f0151721934c33"
    sha256 cellar: :any,                 monterey:       "f86cc6e8950615c14c0b26a5feee5353eb7bf6bbd33dc81f01ff59340d4c71dd"
    sha256 cellar: :any,                 big_sur:        "46c434c3fff63e98b17f14001e5c2f39cce63979b475d434c9bf0253ff6a7ce6"
    sha256 cellar: :any,                 catalina:       "92165a78b9a2f0a23741afd9e854c8096304a5db5be170da6c8fc26fbd6a1cbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c872a6f8feaddd8611e5a9e1efd290fb1e85b0c946ab75edba1d9c589c8bb5e"
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
