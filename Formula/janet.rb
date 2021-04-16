class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.15.4.tar.gz"
  sha256 "8eed302c8ded1df882544d13ce7e415b213cf7bc8fa77ca16110c89b36d19763"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f14978da9ed22b002a960d530705938b4fc2ed5a713faed7afac1d7d753bbdc2"
    sha256 cellar: :any, big_sur:       "6d4bdcbf66437772736501be33523d0ea69e7c4a6709ae1e4d0f7d4441d2c355"
    sha256 cellar: :any, catalina:      "93c2a2fa484e3c12dc8370566270df4786d27b92c2ed093bd04c00bb8c083c29"
    sha256 cellar: :any, mojave:        "3e2db94db94ca83a5ba104ed5898f652fc6eae3678acf9362fba119b40536577"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
  end
end
