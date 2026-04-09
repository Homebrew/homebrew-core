class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "4beb90172c6acaac08c1b4a5112fb616772e214a7ef992bcbd461453295a58be"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80638535c550bc0c889dfb685e886d149fd46583f5f75052cdf06d02878ca9cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12aa531d09c0715dd5ffda73f64634f7f2a38b09dca5bff68ea3083c6fb6b31b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbed3af9274a12efc813725d8dd156f3053c461413d12e016169ff3e80d32d47"
    sha256                               sonoma:        "f9b95ebf0374cfe8fa4e949e8667964db4b2dc76be16c2470e8cfd154a07aa41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e62232a59ffd4afeb89d2656cdd875967bda73af235173798b29468fddfdb85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27379e9f992f8a4e33c48b0fc356f114bc8293c709a7b4c02f009ac435056a05"
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
    assert_match "===> btop++ v.#{version}", log
    refute_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
