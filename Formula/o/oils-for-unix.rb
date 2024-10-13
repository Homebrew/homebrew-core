class OilsForUnix < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oils-for-unix-0.23.0.tar.gz"
  sha256 "c9d35ca78b4a08eeafac8bc6439e2bb40bccd3370db2226487faed6348a17521"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oils-for-unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "7bf02fa96496e8b2a2a200fc6afb6f291e0106204081a4727a927700c5c44c89"
    sha256 cellar: :any,                 arm64_sonoma:   "70b30bf460e32ccfd874c89c11067b20b6623cd19bc1f825453ea34c1035e29f"
    sha256 cellar: :any,                 arm64_ventura:  "76de3593db7b5aae07beb6118e280baa5c17036810ec6101ceef39bb6485d8fb"
    sha256 cellar: :any,                 arm64_monterey: "b5cd80ed7b3430c3aaed7461fce51b88162c2235e370f5bd29b63d57076d48cc"
    sha256 cellar: :any,                 sonoma:         "431ada600584ba373dd189b3e1e5bac7c7916b77f982b6302a41e676d0a06071"
    sha256 cellar: :any,                 ventura:        "4343f49136d3e8ee975c3e272e5be8a0b7fd479969c2d6f0fb3d29b44d829af2"
    sha256 cellar: :any,                 monterey:       "c93128bc87f7d27a2daa7c56d75d361654647043c0d4220a87c91ddb0b477f98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41b43c7d3e5ad3fea25dc19dc24b0458faad3e6f5de692b701cf8a884381c48b"
  end

  depends_on "readline"

  conflicts_with "oil", because: "both install 'osh' and 'ysh' binaries"
  conflicts_with "etsh", "omake", because: "both install 'osh' binaries"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--datarootdir=#{share}",
                          "--readline=#{Formula["readline"].opt_prefix}",
                          "--with-readline"
    system "_build/oils.sh"
    system "./install"
  end

  test do
    system bin/"osh", "-c", "shopt -q parse_backticks"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system bin/"ysh", "-c", "shopt -u parse_equals"
    assert_equal "bar", shell_output("#{bin}/ysh -c 'var foo = \"bar\"; write $foo'").strip
  end
end
