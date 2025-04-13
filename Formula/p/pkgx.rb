class Pkgx < Formula
  desc "Standalone binary that can run anything"
  homepage "https://pkgx.sh"
  url "https://github.com/pkgxdev/pkgx/archive/refs/tags/v2.6.tar.gz"
  sha256 "770944fd946fef2e365d18568335483156ceefa4950ffb9d7b8f98dd2f3fe12e"
  license "Apache-2.0"
  head "https://github.com/pkgxdev/pkgx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "923bc9ae340efadb04b0a3d11bfcf231769109500341b2843e9a0330a991ad65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32b3e4e51dc56a216237e505b9b325a3e7a4e6602cde0a298b90d2c6d66c9340"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15fd4c5304966170b25ffb6e9537c56353a6a2a0a45697a32caf42f52a39e0ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2ac0f44c237dcc86562ef681fac91b8e652b62a6bc746b528a050d60c050f32"
    sha256 cellar: :any_skip_relocation, ventura:       "c7e3c780179e1fe78f0aa8ac11dcd9d411778aab8b70ffc833965c355688c774"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c40b27661351d6658c376bd9bdb8a8020181488a552c7891f54add9f22f972eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac20c4d3fb53c43c9a2ee8f2551cf1d219bf9acfcf5f1de9308c123a84ac2dbe"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"main.go").write <<~GO
      package main

      func main() {
        println("Hello world")
      }
    GO
    assert_match "1.23", shell_output("#{bin}/pkgx go@1.23 version")
    assert_match "Hello world", shell_output("#{bin}/pkgx go@1.23 run main.go 2>&1")
  end
end
