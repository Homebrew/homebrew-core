class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/refs/tags/v9.1.1.tar.gz"
  sha256 "f50db90c7ef95c0964dc980f6596b821f362e15d6d4bab247f1eb4aab7554db8"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9fdd4be90f915c227b082531a803296bea10670202f5b9f43a49f42c96b77cbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "799aee08ac1b340d69807fc69fda8d2acbb30d67c5f95a8e3f7b9276c3cb9271"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac860a10f482704f8b732e43138ab81720fdc4f1af522a27fb44ac3676015c42"
    sha256 cellar: :any_skip_relocation, sonoma:         "51d0acd5344987d04055aff80cee92c15a7e5973dbe10c77ba8903bc9f06048b"
    sha256 cellar: :any_skip_relocation, ventura:        "f5f5bc9127350691ca9e4b6bf2227410578cef12ca0982bbea07e46c8b957da7"
    sha256 cellar: :any_skip_relocation, monterey:       "54b4aef8f48f3dc0c22fd083253ba8136685ede238b3500e9bb2ef9ef9d14b6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "859dc8247db729b83a23d1279d2e5c31b4b14b7f9376838715f832b316b3e7da"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "target/release/assets/oxipng.1"
  end

  test do
    system bin/"oxipng", "--pretend", test_fixtures("test.png")
  end
end
