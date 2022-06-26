class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "07df9d54b6103b4fad2e4ff0cff7f70972a5494adc986c5a864ff43cae610b5a"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88161c8aea0ad2e138d073473a1eb1acdef064eada75dc55b0a211f7de6b8574"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2938efc9220c7972190da3ea9f01df102f785a12a20e66c9076cbb62f425fc90"
    sha256 cellar: :any_skip_relocation, monterey:       "b40743cb3c92c38beb8c0d3cb64f6356e99e5186a038030364b9dd756312b26a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b37cbcd018e6543787937a64076a6e3d40d89a6a72146eebd66f3370c462e62b"
    sha256 cellar: :any_skip_relocation, catalina:       "f015d61dbf3b6bfcf5d197caa0106ae751339e49c13ad732e3479669d3795ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24c745a32973f1e6bba2768d0800a0490390c13dbb376cf9c016af4957e10f8b"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
