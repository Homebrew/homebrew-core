class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.81.0.tar.gz"
  sha256 "7618f98c0ad7d824e8899351c394e77df1ca72f440a80f854b215a7a581fa2be"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "aa5b42c6f8180ec86ba97ac88a46530694e7b1026d3765d5df9ea7c359b708f6"
    sha256 cellar: :any,                 arm64_monterey: "15a2f02b7c216da350022503587adc80e21dcbfa8d4f873133b9e04c58256fe9"
    sha256 cellar: :any,                 arm64_big_sur:  "23a5fee6c0ec2854bb0c7586d985d5e9ba898e3686e48746ac81400209febb0c"
    sha256 cellar: :any,                 ventura:        "3eca998cb9eae7f50463d51a3280f46adba687cb1a881d21e125c9475647ee78"
    sha256 cellar: :any,                 monterey:       "681850ce8a7217ff4e4f40eca41dc8ee43602242da58f3b745f70f411d970b46"
    sha256 cellar: :any,                 big_sur:        "afad2d508a34d52cb2c08e04f52104bb41200e1802fb3aeec2f1f7ec6e7bbe9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a68a3adcade141fec1049371b8994ac3ab52e47a3be8235e20a8cbf4fb50f5ce"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "dataframe", *std_cargo_args

    buildpath.glob("crates/nu_plugin_*").each do |plugindir|
      next unless (plugindir/"Cargo.toml").exist?

      system "cargo", "install", *std_cargo_args(path: plugindir)
    end
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu -c '{ foo: 1, bar: homebrew_test} | get bar'", nil)
  end
end
