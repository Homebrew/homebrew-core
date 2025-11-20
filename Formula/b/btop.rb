class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "0ffe03d3e26a3e9bbfd5375adf34934137757994f297d6b699a46edd43c3fc02"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51bf4b6c17e8d2fd5a4eed2eb6f63aad0239d36d26986b398b59d895dd183794"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf5788f77aeeb642ae9d80430bc6da47ea26e38e8628522f9771e978982eba61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f2006e7d26a7a69a677537c974239f41ad43e961b81115127c0dc62f6503159"
    sha256                               sonoma:        "e97e0797466ccbb028dc113fd21c6b0836b9460e5e52fd0705825b1308b2ff53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c538378976afbf732762684bc823124b289e9c3bd79bc424003e42fdedc84b3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2743b5eaf43985efa2ce7151bb25a71bd6d09eeeb6872a1437a894e395e40310"
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
