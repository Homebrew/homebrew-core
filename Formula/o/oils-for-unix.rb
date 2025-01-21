class OilsForUnix < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oils-for-unix-0.24.0.tar.gz"
  sha256 "df4afed94d53b303a782ce0380c393d60f6d21921ef2a25922b400828add98f3"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oils-for-unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "012109d80ffc6742c105a68a261610c06aafbb3cdcc06b6bb0df3066d7a9f2dc"
    sha256 cellar: :any,                 arm64_sonoma:  "b684c6858dadd556fefc2395bb6cba17a00d5991cfed1c8946d972654152f376"
    sha256 cellar: :any,                 arm64_ventura: "0fcac3d2f7b2e1edbdd85c96ac9c8ba28b255cc23f531409cc213d8e791e72b1"
    sha256 cellar: :any,                 sonoma:        "1fa73c8245bacb5511d3a8567a0dabcbe16ae993d8fe48a054d91d3ec4bb4e85"
    sha256 cellar: :any,                 ventura:       "35f7e663c383b5e4e6abdc332e8b95539959b9a0fa908dba22916a4439ff545e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eb3fa8eef95f11b879bb02657b6ef80faf95f62918424e7e5a89120a6dacd46"
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
