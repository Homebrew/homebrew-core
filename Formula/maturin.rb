class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.13.6.tar.gz"
  sha256 "b29b8262ae2df0daa39cc2c04409ad062eb6f547887a9e1237b6d0ab81888845"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f031cf10a73127cba762d885dc8095f88bf63759f89b7d920327cc5e51001bcd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c316e022102c012c21ee62446d3c6e6a659e7b38c0ba282cdb331db6f40e54f7"
    sha256 cellar: :any_skip_relocation, monterey:       "eec67f50e82e382790ec1e3d035579d165ee81a116f109cf0a73ed204b3b42ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "4090e7e7f41b6ff3c22ae542175bddb3ea66fc67aacfd3123c3aee9dfa1c9109"
    sha256 cellar: :any_skip_relocation, catalina:       "d618e0f4dd211426961812abcdd29c7f6f4482b7d3aa11a4d2236559642d9ffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77620dcb7d403d700dc0e63eb799b5264899b79350454983bb3a564c1b896839"
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
