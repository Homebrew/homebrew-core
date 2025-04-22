class Dps8m < Formula
  desc "Simulator of the 36-bit GE/Honeywell/Bull 600/6000-series mainframe computers"
  homepage "https://dps8m.gitlab.io/"
  url "https://dps8m.gitlab.io/dps8m-r3.0.1-archive/R3.0.1/dps8m-r3.0.1-src.tar.gz"
  sha256 "4c7daf668021204b83dde43504396d80ddc36259fd80f3b9f810d6db83b29b28"
  license "ICU"
  head "https://gitlab.com/dps8m/dps8m.git", branch: "master"

  livecheck do
    url "https://dps8m.gitlab.io/dps8m/Releases/"
    regex(/href=.*?dps8m[._-]r?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "662b0842c1799d9a5321c24202d9769a4684ecf49fccb399c22f5602b278f401"
    sha256 cellar: :any,                 arm64_sonoma:   "8512a997de2d7157aa181b8230286d68336640af6056ec945d5f81033711e893"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34bcbbb25c2dfd78c480cabc2fe15524079bbe3cb2a928166bebac1ef7599b34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23ce64ca8ce99c74b5b50e47ad924980659a4971e569718b88f384146d7ed06d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abe9ac4fb9b51cfbacd7047980ae30712abf795017bab0d50a2ca9a6eb562ee4"
    sha256 cellar: :any,                 sonoma:         "e1e5958347a26b9023e560695fb581b22355d89f7bdc811984fcb4a3fb3ccb74"
    sha256 cellar: :any_skip_relocation, ventura:        "81654fc8c297d212c51325ff99a85a4118b30448f1142a8996f3091159b8df0c"
    sha256 cellar: :any_skip_relocation, monterey:       "9a59be99e76eb327e76dbf8e29bd94b43037689a4287c53ef4d882fbfd0e626d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec9347f931db9539b6a17a5e3dd9559fd8d4eb0fd56aa7c26c8535c40d3a9c52"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d6e3b67195b4a692bda0e617989bbe2a2864a0d0ad47381b3cee12344a38f34f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2607bb961e0b28e82e64392f258f472ccc84335785c703bad7de6b5ebeb1b236"
  end

  depends_on "libuv"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    bin.install %w[src/punutil/punutil src/prt2pdf/prt2pdf]
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
