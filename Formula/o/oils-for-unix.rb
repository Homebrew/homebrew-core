class OilsForUnix < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://oils.pub/"
  url "https://oils.pub/download/oils-for-unix-0.28.0.tar.gz"
  sha256 "266d14b16d90d4a07fe774881eafa0ecdbbc8411cf1c75f8b6e256370b668e35"
  license "Apache-2.0"

  livecheck do
    url "https://oils.pub/releases.html"
    regex(/href=.*?oils-for-unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb1851923cebb32aff65474b7d9ba8d892799724f89930873c4a6b6fde74e583"
    sha256 cellar: :any,                 arm64_sonoma:  "224e6e0e9dd1e7a57f1fac75cd43a0abbeff9644f8cc555a11690da8e8820c19"
    sha256 cellar: :any,                 arm64_ventura: "0e47cd2f6dd8cabc8410e8576422508d6a85ce6bc99df61cbc7408ec0fd7d2f7"
    sha256 cellar: :any,                 sonoma:        "37f150e38d46cde4a7c484ef51e063cc6217b8b92ccf679690a6c3282fc1356e"
    sha256 cellar: :any,                 ventura:       "4e2e73fde180077d979483698d8ee46b46403e24f72ea31cfef3f12b611b14b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98ac5a1660e8c4be26eeef9d111c54e27b755d462411ad9224050735c8b913aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b20d2964a8ac756395f447decc0df3275dfae56ac3fd1dd8f08dc3fc7872f2f"
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
