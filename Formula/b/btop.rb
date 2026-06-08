class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.4.7.tar.gz"
  sha256 "933de2e4d1b2211a638be463eb6e8616891bfba73aef5d38060bd8319baeefc6"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37a9d33566825cff7b0e3e0c4941b2f0a7718405c3c493fb71eaf7100049f429"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00c8110d1d3714206e0dd238c1945e98509940507c8d692a01c5589853f2474f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edc6d6e2c5919d8ccc0d921928091935fecf7ef6f6ecfca5af229e4c8a729817"
    sha256                               sonoma:        "83b0b284cda00fe757da9d09946e0095a4992e450c5ca46607e4d714558170be"
    sha256 cellar: :any,                 arm64_linux:   "83e59931ea0c68cc39c0cf48a3831756293d37bc1a1f42ad682210dc1f20d402"
    sha256 cellar: :any,                 x86_64_linux:  "6c471b70902a92ca7820d4e6b1dcb28e45c3d041ccaeba5e7eeee2fdd78a48cd"
  end

  depends_on "lowdown" => :build

  on_macos do
    depends_on "coreutils" => :build
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
  end

  on_linux do
    # Ubuntu 24.04 has GCC 14 libstdc++ so we can build with brew GCC 14 without impacting GLIBCXX
    depends_on "gcc@14" => :build if DevelopmentTools.gcc_version < 14
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
    if OS.linux? && deps.map(&:name).any?("gcc@14")
      # Since brew will prioritize newer GCC versions if installed, we force usage of gcc-14
      ENV.method(:"gcc-14").call

      # Avoid using the postinstalled specs file which automatically adds an RPATH to gcc@14 libraries
      libgcc = Pathname.new(Utils.safe_popen_read(ENV.cc, "-print-libgcc-file-name")).parent
      ENV.append "CXX", "-specs=#{libgcc}/specs.orig"
    end

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
