class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "cbcb9dbeb741b3cd2207011c117b2ee82f1577d49f4f8be3c07828552ba24c7a"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e17e9aa7db0cea0b7d11816499f2fa99c94029cf565e3e088fdbcec1f029c55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ae8b5525b39c4ed2f91565bc66e29a57e17a71559fb4e4c4a4fa659b4e9b020"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed5b0423367bbc79f4ac856367e537bb324c69782464f24544ec9c25de42a74c"
    sha256 cellar: :any_skip_relocation, sonoma:         "20f05ab3f982896a4b713836e5a099e3c55331d0b90e6347726656af48e61fb5"
    sha256 cellar: :any_skip_relocation, ventura:        "873f31be94d8980629fef2060057e0538435bd9c4318ecb5e2d1c39b803fb563"
    sha256 cellar: :any_skip_relocation, monterey:       "d986b15ae8838fe44d46d189d80c001cd29e37b9a251f663b2ef1f4c0bafeaa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b147366a27b09b21246632617a43b422b332de4f5bab45ee55811074740be0e9"
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
