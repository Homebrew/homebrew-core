class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "23691f9bf60745ee9a9df2ec92a4fc4e77d89cd2648b38410d396b193146ce43"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "938a70b409ab59e873e86e65b7cdffbcdeec57a3cd03fc97fbf5ae83df0316a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e782f8a4e6ae98e46f29cc9074835d8eed20038aad87e73242ae4cae83cccf2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e37626d68bc16a6e303bbf16afdc0acb1dfdc8f5865b71d789bd5175adbec809"
    sha256 cellar: :any_skip_relocation, sonoma:         "81295d553a4744b8c1b434cdc7c5feaee29c4f9ce4e8a5c7d1d201ac2fa6b51c"
    sha256 cellar: :any_skip_relocation, ventura:        "bba1754248f4f78cf4bf4e18d1a26b8d114a654421497fb1be57c9197484de64"
    sha256 cellar: :any_skip_relocation, monterey:       "ee64848bd836ad58ca65a0123d3c4817e32e0338d1dd4fe1d89f0a05e1c450c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73d884067b124a44ba07ac245992a0d98511fa83e0d911e6f64120215c9f2ab7"
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
    output = "[200] 1 responses"
    assert_match output.to_s, shell_output("#{bin}/oha -n 1 -c 1 --no-tui https://www.google.com")

    assert_match version.to_s, shell_output("#{bin}/oha --version")
  end
end
