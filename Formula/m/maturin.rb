class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "b22d15b7dc4f27af50b831af0866bcd901bcce2433182c5b2f252dd420531c0d"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 1
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "47518a23fcf2088986e099be71de79541b9be7eb0fad4c293cd655f6d91cea13"
    sha256 cellar: :any, arm64_tahoe:       "40f95b534ebee4f9a7c4b6319cebfc7aa40c7defdacb9abcc89d37f352a9f1b2"
    sha256 cellar: :any, arm64_sequoia:     "64f7c0cfe9297954a1d7b7a8a9f149a5719b7360a6d37b75a075201e591d411e"
    sha256 cellar: :any, arm64_linux:       "024566cd51195d70510dbb0c45c5efb88b50ffc832c9c8fe403ac2fd6fc50620"
    sha256 cellar: :any, x86_64_linux:      "964114a2c9bbbeffd950d1ea036957048bd6f1c3cb1eeb489a4bd3a61ab9d267"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => [:build, :test]
  depends_on "python@3.15" => :test
  depends_on "xz"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"maturin", "completions")

    python_versions = Formula.names.filter_map do |name|
      Version.new(name.delete_prefix("python@")) if name.start_with?("python@")
    end.sort

    newest_python = python_versions.pop
    newest_python_site_packages = lib/"python#{newest_python}/site-packages"
    newest_python_site_packages.install "maturin"

    python_versions.each do |pyver|
      (lib/"python#{pyver}/site-packages/maturin").install_symlink (newest_python_site_packages/"maturin").children
    end
  end

  test do
    system "cargo", "init", "homebrew", "--name=brew", "--bin"
    cd "homebrew" do
      system bin/"maturin", "build", "-o", "dist", "--compatibility", "off"
      system python3, "-m", "pip", "install", "brew", "--prefix=./dist", "--no-index", "--find-links=./dist"
      system python3, "-c", "import maturin"
    end
  end
end
