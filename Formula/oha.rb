class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "7bac8733d4f192d5437d8e4b493e58c9adcc8eefd5c9f00a2380106d5077d57b"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61fab889751f5252b33b001058c75e0cfcb6f9b20cb3e2aff7dcbed82e6c746b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5f2fedb2cc39f71b32094277a23c0b1ed968b914223bf5a75c750059ca7124d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b98220435a472c43da2f7ac903df289cedbb01c84c29e65a28e3f49587d32d7b"
    sha256 cellar: :any_skip_relocation, ventura:        "b3ba77c0dfc5b306a2f7a201d44f57ec340cc81cb59dbe2b95a67ccbb7a51043"
    sha256 cellar: :any_skip_relocation, monterey:       "9dd9d721523baf98e7066acc3f5ef3d6ba9b430e66db47734790dcc161768b65"
    sha256 cellar: :any_skip_relocation, big_sur:        "fca975c60b261fa9d41cc24fd931b83b12c821db57efa24c6514e0ea2eb3745b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "756db069c9ac0961799148acb2c63717f498a741587e6ef76d6f4fd66b9eed9d"
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
