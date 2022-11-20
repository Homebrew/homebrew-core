class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "3a15ebdb8780a4db1603c887c5bc4ba8aa689bbf6914d8d9852d05ec57e2464c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ff802d80a7b19d7412fb96d1d69a46d4ce0b60dd49b9a0ea76170ad3013719b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b30a4e2f406424e555418afdd6ed925fd2fc21476518de1a2b5e42ebfae2f33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1555858e36138f548c0c7aad4e550cea9b7909465b481d90378e85527918ae4"
    sha256 cellar: :any_skip_relocation, monterey:       "3191ebf923b1dd747415ac48c4fdbd719a9955d38a5fc395c362ed1d502e2175"
    sha256 cellar: :any_skip_relocation, big_sur:        "599ec838c6669c9a830ce3957819aa0f2f4c6294727658e25e276dab1deed5c7"
    sha256 cellar: :any_skip_relocation, catalina:       "e97ec236a050eb955463edacbdffba5c047042620d3518a03e4352ad04a34687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7e07056fba631763704f8550b79506251b56df24f01cec84964cc61e58c55af"
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
