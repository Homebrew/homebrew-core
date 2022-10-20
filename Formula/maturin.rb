class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.13.6.tar.gz"
  sha256 "b29b8262ae2df0daa39cc2c04409ad062eb6f547887a9e1237b6d0ab81888845"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6070ad360d33a7ceebd778a0e1cec8ce811e203701e70625e76ffdc3b7c7e793"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fbedc60a820df76ee03679688fe3e92d11159c49e05c7b007a0e6f52b55a108"
    sha256 cellar: :any_skip_relocation, monterey:       "f098dfada0b445b2e110dcb97b60f9455e92a7bddc1cafc099c4fe0a8965a16d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4a6702af455e73512730cfab9145df39dbdc4798f00f0ee94d48bc405b60bec"
    sha256 cellar: :any_skip_relocation, catalina:       "cca1465f234f70b482ea7a9ba823900741608a57d1f7569f1dda3480e9b72661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b433c59e497bdbe20ec0bffb730f943dca9867b7cd5208cb478b7c755e39792b"
  end

  depends_on "python@3.10" => :test
  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"maturin", "completions")
  end

  test do
    python = Formula["python@3.10"].opt_bin/"python3.10"
    system "cargo", "new", "hello_world", "--bin"
    system bin/"maturin", "build", "-m", "hello_world/Cargo.toml", "-b", "bin", "-o", "dist", "--compatibility", "off"
    system python, "-m", "pip", "install", "hello_world", "--no-index", "--find-links", testpath/"dist"
    system python, "-m", "pip", "uninstall", "-y", "hello_world"
  end
end
