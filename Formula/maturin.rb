class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.14.10.tar.gz"
  sha256 "8fc9bcdcb7f1535d5e3e8bb500c348ca1bff5a6dce87b0ab7dbc5a49723da28a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e87d678aa57f5ae1243bd1b94edf2dd872d691937c340865b0dd01b0a6c5035"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31a6cda12983f216ae0c805d65f5f6198d36b5f9a304418dad60cf55999d24af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bc808ebb893ca6604fb57c46714724e6ca377e60290bb8f7f298ca22a35a21b"
    sha256 cellar: :any_skip_relocation, ventura:        "6b33e0b6eb8a0a164f96a73f7464ac0df33ea1ee8954939fb7ceac49a0f6c287"
    sha256 cellar: :any_skip_relocation, monterey:       "57e154df4ef03b6e88593a4ae534a57a5361f8ae7be8e2e89530169668989190"
    sha256 cellar: :any_skip_relocation, big_sur:        "978df57383fb9e5e7224f649f057279f0424de0cea1179b56fe6f859b1fa5e26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "508066a0ae7cc013bb2e6261fc642bf66a20941347a02869be55ae697a590525"
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
