class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "623111bddb2d7f6f4ba2e64038f91f8b673bd6f95dd6fcbaf334b7af7789b48d"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0d9e5afc1c1362e5c883b3f4d23a77f6b1b7b5b33ca8b527fdd7b9741cbff428"
    sha256 cellar: :any, arm64_tahoe:       "86402b3a2b419ea2af740d7cf154e4c17b8ca653a33a01e81ab68a730748a96f"
    sha256 cellar: :any, arm64_sequoia:     "15c8a97c9734a2fb7bb15c077877804ba96a8181f07ca5d69cf96f975d20aef2"
    sha256 cellar: :any, arm64_linux:       "fbb5906ffdeeb1b89d7abf9b49ff0391c4b812533790931491840d0eb41095d2"
    sha256 cellar: :any, x86_64_linux:      "2d54d813edb5375539436a0d7679fbf4bd9a194bd396380b443cc57e0b167685"
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
