class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "d97cd744f17eaad77e4fc51ebc0dd3f29530cbbb293b348088e2eca81f49570d"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bbd97e38f8217554095d3deae77094c65d62f0695186ab188f58de07f289d4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0619cf1b39254a0a224557ea823f566e32f71527f60708c809264e87579a1524"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a45857150776f32f3f5c491cf8e61b89b25df7e9008914de315ac8cca7fc7ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d1d45fe1bee10f967edd21c41da33b54b1590d3524c594e92693a95de0b0bd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "508035da10ff2c334e689808b082e3882eecc690f5a3c3995a4206ddf9f37409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edd56ac77168c70386f7722ea87a85412430a63e55592eba89e066af79d810c4"
  end

  depends_on "cmake" => :build # for aws-lc-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 1 responses"
    assert_match output.to_s, shell_output("#{bin}/oha -n 1 -c 1 --no-tui https://www.google.com")

    assert_match version.to_s, shell_output("#{bin}/oha --version")
  end
end
