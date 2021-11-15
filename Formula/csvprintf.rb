class Csvprintf < Formula
  desc "Command-line utility for parsing CSV files"
  homepage "https://github.com/archiecobbs/csvprintf"
  url "https://github.com/archiecobbs/csvprintf/archive/1.1.0.tar.gz"
  sha256 "a64e48a81a4416f47c224a67b9554c93763429e25e4b15e0d23f3067bd6a0ffc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93298c8242cc45869ba715c99354285a56814d9bccc7edd3ea7769b9a13489c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8afbe3e5b8700c87735bc13b57bfcd617e4fb3a1520fa775c8166fd5ca82281d"
    sha256 cellar: :any_skip_relocation, monterey:       "3ff3dbb23600a49ba231f0348388c37d62547f466d839ad6a17e1461dd27067b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a11cedca73677e40d9ce558e0b00e7709574dc2dd631a054121b7607c1261e2"
    sha256 cellar: :any_skip_relocation, catalina:       "42b91fd076c4f85bc0ec69ba1c9ae4d32a5a64b4070eb5859ee1e71199049f0f"
    sha256 cellar: :any_skip_relocation, mojave:         "5fb842063d45968a558825af7a4dffcf5ef8258c9bd0c29c1b94657ac8fbab9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8586df7d62cef4aca13955d98d0b661b2b2c93906060ac564dc4b81ad38d60a4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "libxslt"

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "Fred Smith\n",
                 pipe_output("#{bin}/csvprintf -i '%2$s %1$s\n'", "Last,First\nSmith,Fred\n")
  end
end
