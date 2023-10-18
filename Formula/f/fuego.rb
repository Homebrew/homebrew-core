class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "https://fuego.sourceforge.net/"
  url "https://svn.code.sf.net/p/fuego/code/trunk", revision: "1981"
  version "1.1"
  license any_of: ["GPL-3.0-only", "LGPL-3.0-only"]
  revision 8
  version_scheme 1
  head "https://svn.code.sf.net/p/fuego/code/trunk"

  livecheck do
    url "https://sourceforge.net/projects/fuego/rss?path=/fuego"
    regex(%r{url=.*?/fuego[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "3a061001a9eca05e325adfed33177ac1bc202630cb5f3e25d08164bb9b1f9b7c"
    sha256                               arm64_ventura:  "06890a3d1347acdd9e649ad8e4acf0550dd28433714b6209f6a0141211a8cfe9"
    sha256                               arm64_monterey: "a8983c437ff9569fd1522caf18587ca5762b69c87f1c031883b9e1434334a646"
    sha256                               arm64_big_sur:  "c93ac5638af3341fc303a42d53bc6d12dc0050226375c946cba49d7569c824e1"
    sha256                               sonoma:         "411a20fb38fb4775e205e8685c62988b0b58cabd77c340fb0677149ecb9b8fb0"
    sha256                               ventura:        "9e5b53ce50849ea3fc956d1331d938d63a79ce697cbdf3d40d915d0cead44dfa"
    sha256                               monterey:       "42ea788205a9bcc7ce791f67b115eac318bfb77380b55f1f28b5d8e9fa633ff9"
    sha256                               big_sur:        "cecaaeb1231f41adf183bb783a93a1b61c39e43b90bac0e69bb9d89ce0fdb494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efdaf825259a3a7c7f5198e481d76072d0ec6cff42903966fb67462b9dd7a0d1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"

  def install
    system "autoreconf", "-fvi"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make", "install", "LIBS=-lpthread"
  end

  test do
    input = <<~EOS
      genmove white
      genmove black
    EOS
    output = pipe_output("#{bin}/fuego 2>&1", input, 0)
    assert_match(/^=\s+\w+$/, output)
    assert_match "maxgames", shell_output("#{bin}/fuego --help")
  end
end
