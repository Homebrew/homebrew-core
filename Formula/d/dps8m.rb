class Dps8m < Formula
  desc "Simulator of the 36-bit GE/Honeywell/Bull 600/6000-series mainframe computers"
  homepage "https://dps8m.gitlab.io/"
  url "https://dps8m.gitlab.io/dps8m-r3.2.0-archive/R3.2.0/dps8m-r3.2.0-src.tar.gz"
  sha256 "efd2e0e80cc9d47aad31126dcaa065c2d5fa688966f38397d9772c6781ce8b61"
  license "ICU"
  head "https://gitlab.com/dps8m/dps8m.git", branch: "master"

  livecheck do
    url "https://dps8m.gitlab.io/dps8m/Releases/"
    regex(/href=.*?dps8m[._-]r?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    manifest_sha256 "a1855988074687c4977155f1767111f47964be18a12c86c0b29de14fedcb1a96"
    sha256 cellar: :any, arm64_golden_gate: "c90115da8fefbd1cf4ea16d4a795475635f87c54a9cc44c720eb8f392db65db9"
    sha256 cellar: :any, arm64_tahoe:       "7d624561174198c37054e105b5bf0eabded0715fb94e5c9cc62b6a2b8ab0bc80"
    sha256 cellar: :any, arm64_sequoia:     "ec27c16ccf46e757a71387f0cad76137a0acae5d768835d767e1b28904557148"
    sha256               arm64_linux:       "6e62521cec0b9a8fb6ab81eda9ac3b1bf2f694f7033442ce3a06329db49fecda"
    sha256               x86_64_linux:      "ca5cb8023634c28c24b8860e9113a8454babf88ed21d0bf2dd0a171890fef918"
  end

  depends_on "lld" => :build
  depends_on "llvm" => :build
  depends_on "libuv"

  uses_from_macos "bash"

  def install
    if OS.mac? && MacOS.version < :sonoma
      system "make"
    else
      # Upstream issue: https://gitlab.com/dps8m/dps8m/-/issues/293
      inreplace "src/pgo/Build.PGO.Homebrew.Clang.sh", "exit 1", ""
      inreplace "src/pgo/Build.PGO.Homebrew.Clang.sh", "$(brew --prefix llvm)", "$BREW_LLVM_PATH"
      ENV["BREW_LLVM_PATH"] = formula_opt_prefix("llvm")
      ENV["NO_PGO_LIBUV"] = "1"
      # Xcode's `ar`/`ranlib` can't read the LTO bitcode produced by Homebrew LLVM
      ENV["AR"] = formula_opt_bin("llvm")/"llvm-ar"
      ENV["RANLIB"] = formula_opt_bin("llvm")/"llvm-ranlib"
      ENV.append "LDFLAGS", "-Wl,-rpath,\"#{formula_opt_lib("libuv")}\" -L\"#{formula_opt_lib("libuv")}\" -luv"
      ENV.append "CFLAGS", "-I\"#{formula_opt_include("libuv")}\""
      system "./src/pgo/Build.PGO.Homebrew.Clang.sh", "LIBUV="
    end
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    require "expect"
    require "pty"
    timeout = 10
    PTY.spawn(bin/"dps8", "-t") do |r, w, pid|
      refute_nil r.expect("sim>", timeout), "Expected sim>"
      w.write "SH VE\r"
      refute_nil r.expect("Version:", timeout), "Expected Version:"
      w.write "q\r"
      refute_nil r.expect("Goodbye", timeout), "Expected Goodbye"
    ensure
      r.close
      w.close
      Process.wait(pid)
    end
  end
end
