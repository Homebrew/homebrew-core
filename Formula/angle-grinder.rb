class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.17.0.tar.gz"
  sha256 "5a2054ba9eb5fcee1fef2d5fbbf1735e71bc563fc7b273890097f63297e64bf4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "782939f8ddc8b9c0c15e0a45b0f36d546a6771a27f6273cfb7fbbe580d6e8149"
    sha256 cellar: :any_skip_relocation, big_sur:       "74c4ae3251570186fe78ad4f55355e006a268d9eeab81405b61cd719aa931316"
    sha256 cellar: :any_skip_relocation, catalina:      "fd9b197c1537ef416c48ff759fb7889f4061aaca877b40f1b424c872e63e4dc8"
    sha256 cellar: :any_skip_relocation, mojave:        "29b8a96121053b1b604a21f93819c4ee9e6bfeafba7de24b7798d2367ab69b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10e7831dee92f88d81165b878011b62c50c7cbab1d8a8f5e79cf389cfe6bec10"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"logs.txt").write("{\"key\": 5}")
    output = shell_output("#{bin}/agrind --file logs.txt '* | json'")
    assert_match "[key=5]", output
  end
end
