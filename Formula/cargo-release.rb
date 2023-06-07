class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.24.10.tar.gz"
  sha256 "56aa9dbf85dc14b2d6ea6e0922fd0464f45af09e2aa26641c6db84d61e2de543"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ecf4966bcff0d7a785326f8fe85168eb04c6b6067b97c1e1559ecc32182f421"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d123d81e659df9c992b583ff4c7bacc54200adbb3a270f635d8c857a918e0d3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63f881effdbbfb15892c362c2f1a2ad31b7f23ee3ccf81ed2dfae9c72f6c7d01"
    sha256 cellar: :any_skip_relocation, ventura:        "20a84cb51f63a46ccc9690df708114bb036677fabd222f8d3e04fda8e687e5b3"
    sha256 cellar: :any_skip_relocation, monterey:       "fcc61937e3dce422ae09d05196741a8b376431ed00d26599d87cae853a22a1cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "f63afa294fd548429ccd5b3e25c907348cfeae21a2dd200ea3a0387fd10435a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d63c11ca314240c51f31f66765f8daa1dcfd8ba9a7feb01de8eff9ec21096da1"
  end

  depends_on "rust" # uses `cargo` at runtime

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      assert_match "tag = true", shell_output("cargo release config 2>&1").chomp
    end
  end
end
