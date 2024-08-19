class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "331d18488b1dc7f06cfa12cff909230816a24c57790ba3e8224b117e3f0ae03e"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "e2d3ce97c7b2dab1c4647631687f4884cb9078fe59d9009ea54d5028c2669703"
    sha256 cellar: :any,                 arm64_ventura: "ac19df269dc2da0586011c7e93ba0606d178f1f5840afd070c34d8e29404420d"
    sha256 cellar: :any_skip_relocation, sonoma:        "73b9683780fdc4fcb996644990f37524a424daf4ad6333d23ce9a1ad9eea3281"
    sha256 cellar: :any,                 ventura:       "619e5e3fab0c6c5074d94baaa1c37837035731a729d48deba4a1db7bb2ce4ff4"
    sha256 cellar: :any,                 monterey:      "5e509f11849bb625bfbd972a8078f9735b70448d5b3d73744d8c88e300651a90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16e1fa0055f26d4d30a7437fc2c41d6d626271c09fe1e092099d01b58aa340fb"
  end

  on_macos do
    depends_on "coreutils" => :build
    depends_on "gcc" if DevelopmentTools.clang_build_version <= 1403

    on_arm do
      depends_on "gcc"
      depends_on macos: :ventura
      fails_with :clang
    end
  end

  on_ventura do
    depends_on "gcc"
    fails_with :clang
  end

  # -ftree-loop-vectorize -flto=12 -s
  fails_with :clang do
    build 1403
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "9"
    cause "requires GCC 10+"
  end

  def install
    system "make", "CXX=#{ENV.cxx}", "STRIP=true"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
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

      r, w, pid = PTY.spawn(bin/"btop")
      r.winsize = [80, 130]
      sleep 5
      w.write "q"
    rescue Errno::EIO
      # Apple silicon raises EIO
    end

    log = (config/"btop.log").read
    assert_match "===> btop++ v.#{version}", log
    refute_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
