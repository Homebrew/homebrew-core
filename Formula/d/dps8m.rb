class Dps8m < Formula
  desc "Simulator of the 36-bit GE/Honeywell/Bull 600/6000-series mainframe computers"
  homepage "https://dps8m.gitlab.io/"
  url "https://dps8m.gitlab.io/dps8m-r3.1.0-archive/R3.1.0/dps8m-r3.1.0-src.tar.gz"
  sha256 "4f09cb3e0106f39864617f17f3858e15cca1e9588fd50dde9bc736808f89e26b"
  license "ICU"
  head "https://gitlab.com/dps8m/dps8m.git", branch: "master"

  livecheck do
    url "https://dps8m.gitlab.io/dps8m/Releases/"
    regex(/href=.*?dps8m[._-]r?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5d60fd88809f95e134a996e6f9d03f9b8b5f4d82d2da4ea0ea6861e44883a5f4"
    sha256 cellar: :any, arm64_sequoia: "2299a62a4694d96a06590dda48aec1b5bc7d4223a16027fc8d7e2815b89ef96b"
    sha256 cellar: :any, arm64_sonoma:  "0c1ab00fc50dc0faab0615c50f338d6f65539861eccc49efce8a2e672d91de13"
    sha256 cellar: :any, arm64_ventura: "807a98a81f8d7abb726a736adbe55e65b4ca015b7019fc96f76032cd1c38431e"
    sha256 cellar: :any, sonoma:        "0690eb787b730de5eea8250c1e1b649f8662e531650be0fe7b37e83eb6e68c4c"
    sha256 cellar: :any, ventura:       "b2e4de813094ec39ec4cebeb41fba5e8a4cd7980a1827725103da70aa016dad0"
    sha256               arm64_linux:   "a36ea1366280f8b91a7d40a189eeda1dcfafcbf4911e36ed5e4157f35dbe5e08"
    sha256               x86_64_linux:  "dffb4ef88aa0f51558f805fc3ad1bb8cba22c48155a6d816fa194552df2cfd49"
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
      ENV["BREW_LLVM_PATH"] = Formula["llvm"].opt_prefix
      ENV["NO_PGO_LIBUV"] = "1"
      ENV.append "LDFLAGS", "-Wl,-rpath,\"#{Formula["libuv"].opt_lib}\" -L\"#{Formula["libuv"].opt_lib}\" -luv"
      ENV.append "CFLAGS", "-I\"#{Formula["libuv"].opt_include}\""
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
