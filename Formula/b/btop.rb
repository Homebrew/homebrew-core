class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "81b133e59699a7fd89c5c54806e16452232f6452be9c14b3a634122e3ebed592"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "489cced3f7450b6cea1f2261a91ecfbdf1bac5d34345a048493eb3dddeacc851"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b96231c24642d19ff74812f602d6bc01c968feb68bd02cdd5e2989ef757fd0c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f915571ec57b88e6cf019b23f29bddb8dbe4826cfac1f5497936bbca0d1d4b15"
    sha256 cellar: :any_skip_relocation, sonoma:        "807770d8ad61da28c1383494f66c464d003d3cf78cb0cc0caa84d34c5b384582"
    sha256 cellar: :any_skip_relocation, ventura:       "9c59b21f9b75682d4643d9d3feddc7c0d3e22f64bbca95ffa350520242246e1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1affce02155f1b2919633db263d0e3e4934148a514c7bcece6c1289da20d2a23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97214938f020732369eb717dd8f967519d2131903f3cc10dd0041e6d1c0e1773"
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
