class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.4.7.tar.gz"
  sha256 "933de2e4d1b2211a638be463eb6e8616891bfba73aef5d38060bd8319baeefc6"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "844f051db2955c0a0a11ee1634313b635ec192b3922ecb519dcf050f60a610ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "853866a08592bf895324bbd637148d623cb83b1cd36e7a080c7d414f463c00a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70955db3ee586eb4144a6f2032d66bbe2291dec28e1dcf2b306d9d080d107424"
    sha256                               sonoma:        "faecdc31554282d43c9e2a4bb10ec563a573fdd29269284556941fdea59911af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8fb6c3c6b161915d97b8a51b962ccb16f663f6dcfd4c915f4c7d7ed80bcdaa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b07bba0ef5de2cc919669e86f3deb131d5f548e72d32198c4cde58bfb8bcdc34"
  end

  depends_on "lowdown" => :build

  on_macos do
    depends_on "coreutils" => :build
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with :clang do
    build 1600
    cause "Requires C++23 support for `std::ranges::to`"
  end

  fails_with :gcc do
    version "13"
    cause "Requires C++23 support for `std::ranges::to`"
  end

  def install
    ENV.append "CC", "-D_GNU_SOURCE" if OS.linux? && Hardware::CPU.intel?

    system "make", "CXX=#{ENV.cxx}", "STRIP=true"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    # The build will silently skip the manpage if it can't be built,
    # so let's double-check that it was.
    assert_path_exists man1/"btop.1"

    require "pty"
    require "io/console"

    config = (testpath/".config/btop")
    mkdir config/"themes"
    begin
      (config/"btop.conf").write <<~EOS
        #? Config file for btop v. #{version}

        update_ms=2000
        log_level=DEBUG
      EOS

      r, w, pid = PTY.spawn(bin/"btop", "--force-utf")
      r.winsize = [80, 130]
      sleep 5
      w.write "q"
    rescue Errno::EIO
      # Apple silicon raises EIO
    end

    log = (testpath/".local/state/btop.log").read
    # SMC is not available in VMs.
    log = log.lines.grep_v(/ERROR:.* SMC /).join if Hardware::CPU.virtualized?
    assert_match "===> btop++ v#{version}", log
    refute_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
