class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v9.0.0.tar.gz"
  sha256 "534fa8f349f52b01c2ee4332cef25ce1311edca04209ac6d972e38b171550a1b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "515a50a042def4794a83acc53185f281bce8312a6ec082f607c294694eac1229"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f25c738b7ccd0fdc1445e00e57f90f50c1053cc5935223a381f158473f576a54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "306871ca772324b194bf16058923755a5fbbd2aacfbbf4bc81bfe216f1748cfb"
    sha256 cellar: :any_skip_relocation, sonoma:         "d70214dbc046088a04dd949acedc15bc81b39a8fb6e5c0adde08fb509284665a"
    sha256 cellar: :any_skip_relocation, ventura:        "3f16034e85b67e9927f23067ec3dc4050c1206dda80ad2b83d6ac49c8cbe2f8e"
    sha256 cellar: :any_skip_relocation, monterey:       "84313801552949295a5148f6c0cc4ab941b8035a7951c05ad80c7fb3a73604a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54a62a64b21a2a312e3c54a8379230a4e857d9cff7e2cb664b277a8e7e6bebc0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"oxipng", "--pretend", test_fixtures("test.png")
  end
end
