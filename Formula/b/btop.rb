class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.4.8.tar.gz"
  sha256 "67e07c21b770a6d884c5e50ba1d2cfc90732ea57459367d8732ec7ecbeb3be5f"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8414523e63c686c1e33e8ccaf225e64e49b98e7c93a36f00ae385b630853227b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f7d7c84714637054285b2afb9887ea97d915b85902d66ae4e533baf196639b1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "df46dfdc76caf0ae48eb013bb50557baaf3fba82a43fe62047305dd0dc03d194"
    sha256 cellar: :any,                 arm64_linux:       "da03ce7be074d6e3a844fbb4df04d204d9663c1cc3df9019fd9452774e5defb8"
    sha256 cellar: :any,                 x86_64_linux:      "0fd909f7c8a4c6252627bca79554041dbcc734c6c94faf4ff0724e0cc89fa07e"
  end

  depends_on "lowdown" => :build

  on_macos do
    depends_on "coreutils" => :build
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
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
