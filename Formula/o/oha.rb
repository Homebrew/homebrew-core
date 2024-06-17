class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "dfed8814c74419ab7bdc545bbd778f69ccc515defd5f756d8368c3c1b74d2cc2"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65c3fe764b2fd34b6fb548837cc87c07570deefa48af29beafc86fa9e0dc3f22"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea595329ee844f9d4292d47d1ddfdfd92d02ced1d97571aa78491ef48395c0a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81cb16e38c3629037dfc7f74b993e2e840d27aac3c79518f288ebb697f34c3c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d7f19639e4b3d84036139d86eb7a96ef29a0473c8762018a50ebd30ea3fdc17"
    sha256 cellar: :any_skip_relocation, ventura:        "2430553cef3a70ca01f19b7e37747cccfaca2b92dc6ae78a1f6665a4e3b52137"
    sha256 cellar: :any_skip_relocation, monterey:       "612c067eabe20d94825d45f5186cdee675bf449e6d2e26eb88be7ecc7da7edd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f1c601bf7a178d6a2730d148a248b678630af6fc2a2b2b2eeb0f2a8c306673a"
  end

  depends_on "cmake" => :build # for aws-lc-sys
  depends_on "pkg-config" => :build
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
