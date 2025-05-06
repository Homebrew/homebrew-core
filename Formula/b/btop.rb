class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "c7c0fb625af269d47eed926784900c8e154fdf71703f4325cffdf26357338c85"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f54aa49bcb59a1631a295dbf1cf90d487e14f429fac1e208aed4ad906e7cb69c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3b1d47b80a73e509b6a045a32cf13ed94b948193a2de93483bafa7613cf78af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "379d95087b0a3fa4665848fa1a8276e55c891ed6c2cb6ed50a7b540f124ba2c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dfee36207403d9197735cbd717d5476c7bb653d41a1e7e3f90b429a617ef753"
    sha256 cellar: :any_skip_relocation, ventura:       "39146fc5dbfbfaa025e06f07acc70c048d0336ceadf50527880cf3aa9bf712c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0710e9ec2d181e4e072155499178432d52a5c42afd26674b066e693c62a24e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "512af0dc52a737d26afe93a056f5eb3dad2b17e1be4e014178c218c15577c70e"
  end

  depends_on "lowdown" => :build

  on_macos do
    depends_on "coreutils" => :build
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1499
  end

  on_ventura do
    # Ventura seems to be missing the `source_location` header.
    depends_on "llvm" => :build
  end

  # -ftree-loop-vectorize -flto=12 -s
  # Needs Clang 16 / Xcode 15+
  fails_with :clang do
    build 1499
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "9"
    cause "requires GCC 10+"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1499 || MacOS.version == :ventura)
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
    assert_match "===> btop++ v.#{version}", log
    refute_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
