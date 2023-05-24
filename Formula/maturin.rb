class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "d3a8dd7ec0e031981bf693b66c979e787f03cef9e55c893f4b49ebbfad7144dd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b190ae6905e086979e9704be1e6693f727a033bf45e94b43fb633239c9959f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4084e2e00859b6bf77f94252db9425e3c3c2e2fee2601bfff2745f9de9ffb31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65fe7c9f30692b86b4186fb395b27dc28d1ce3b7a88cbe77d6de8f813e6c5dca"
    sha256 cellar: :any_skip_relocation, ventura:        "2bb57e2ac7e7f5f2833153a35e97bd6f9ac6458dc5fa6e84658aab7f4759c8a2"
    sha256 cellar: :any_skip_relocation, monterey:       "db0f7aec2b72f0133f65e3394b22967722ea7b2b6dd7193a8792261a349dc1ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7c22143142852f65e032ae15a8e13dce2a074a4b8a0f29be38fa3136dfecfb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c862aebc39ef1cb7cc864fc2d2f84107f791b16415da1403b05f2f865668aeb7"
  end

  depends_on "python@3.11" => :test
  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"maturin", "completions")
  end

  test do
    python = Formula["python@3.11"].opt_bin/"python3.11"
    system "cargo", "new", "hello_world", "--bin"
    system bin/"maturin", "build", "-m", "hello_world/Cargo.toml", "-b", "bin", "-o", "dist", "--compatibility", "off"
    system python, "-m", "pip", "install", "hello_world", "--no-index", "--find-links", testpath/"dist"
    system python, "-m", "pip", "uninstall", "-y", "hello_world"
  end
end
