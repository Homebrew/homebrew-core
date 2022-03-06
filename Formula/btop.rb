class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "93ff23276f2c626282037766542543dad5964fb6117c7902c4a4899607f8c95f"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "04ad82b13e5f43d91b84197a881b356363dc9af1e00a025102c33b7630dcfa56"
    sha256 cellar: :any,                 arm64_big_sur:  "d9daa68ef616a418b24ad15a5b812bbeb069ed9986b75f3ab020c85bed5eb709"
    sha256 cellar: :any,                 monterey:       "02700d9c092660130725865728f730d4e81bd5a43a5070dcdb9c107e6548dd70"
    sha256 cellar: :any,                 big_sur:        "24de9a4de92073b48639218832123299ee2dc17cbf4121b34a065f5e2eae985e"
    sha256 cellar: :any,                 catalina:       "050cd9436e965e6b77d94287acb80de9acfdf6b6639923e9c89cab46e2fc8272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52a701e94564ccbc52893fe8203bc97447122b0975c072b6570db8d3f64ebf53"
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
