class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/refs/tags/0.9.3.tar.gz"
  sha256 "c73827af830b4c54903143839ea29651a991574ce6aded613fc077d095ac0c14"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ebb5ec0b3bdc935213b1db4a911016e0354a0d0bc72da0ad400059990d0fd6f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a0bcdcf3937c25cf5fb85509f8571270d3b90fb122e3a9784fbfe0ba2f940d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a5063d7d983d326d67163c6c2d8ac92d81c37525403fa6e45f3b3ea526f7a71"
    sha256 cellar: :any_skip_relocation, sonoma:         "945c21a64e36626172560823bb1329eef9659c094e0bc139bb41354aff6a4c83"
    sha256 cellar: :any_skip_relocation, ventura:        "532dcb33d08e4b51c2a019b8d2a585528af6f5f1fcc25c4b932f3974f3bc7c35"
    sha256 cellar: :any_skip_relocation, monterey:       "76e6b56e4d72d2dbce83d4e5af4dba0c4b9f60d49bea8c2c704c1ace70cd4f97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c2a67ee136951625922cb98405ff793f41dee829d95fa18e6040e7c19c2ff7c"
  end

  depends_on "rust" => :build
  uses_from_macos "bzip2"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", "--features", "tls-native", *std_cargo_args(path: "duckscript_cli")
  end

  test do
    (testpath/"hello.ds").write <<~EOS
      out = set "Hello World"
      echo The out variable holds the value: ${out}
    EOS
    output = shell_output("#{bin}/duck hello.ds")
    assert_match "The out variable holds the value: Hello World", output
  end
end
