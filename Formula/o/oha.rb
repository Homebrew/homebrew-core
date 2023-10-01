class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "f64bd61637f9cfbacc6ae45fc2cf7565c21bdac4ce0bb946c62803be9480f3d4"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c633858514e81ba5f04f7db764863ebd8c061ec98327260756a33bb324930c59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a3d55dcce1fdbc03ae242ee4b8908545c7114120dfe46befa7cb45a969f20fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2f03b63bcac4b04a7504b0679623659563fa9f709311b9ea88777071e4f165a"
    sha256 cellar: :any_skip_relocation, ventura:        "524ddbb82b31ebdf916a18e69df8e268897b72b58a65beeae1dcb67cb27278f4"
    sha256 cellar: :any_skip_relocation, monterey:       "eaecdf50dbc1936c56520dff3929597a55af1c17d86da6b6512863f4de3df96c"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd77d98386c719b01930812852f57965fdbc5bff8244278e596a53cbb7e36f4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "887e767632d01d7fa1c04be083d50517bf75ff1bd2ea05dc63ca1c2b3558f13e"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
