class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://lychee.cli.rs/"
  url "https://github.com/lycheeverse/lychee/archive/refs/tags/lychee-v0.18.0.tar.gz"
  sha256 "56127481c8684b6f611a22e3940dacb06abf6db6ea24d1af38ccefe91bc09dbe"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f01661ebbdc9d7eb66c8f9699a8a96c2afb661ab2f77eb1743de6cac3a556948"
    sha256 cellar: :any,                 arm64_sonoma:  "66069fbc154c6043a20a8e1f8e790ba643a3b10fb20b04ee8f37c77be1c0b1e1"
    sha256 cellar: :any,                 arm64_ventura: "a6cb858c378dc4aae9301e2021b8867e6e0f406022135da98529fcbc41438553"
    sha256 cellar: :any,                 sonoma:        "fb589459ee6a636e4121a2e7e67e8cb62f485f455ce7d81eef652eec8393c23e"
    sha256 cellar: :any,                 ventura:       "56c93a6348c63e31fd910bea61d9ff6d31786fcfc042ec9000238eb1835b9ce6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b438c0a8636f69aa3a00f92ddc19a708ad691e7ff18a0efc90b856aa7dc0c6c"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "pkgconf" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "lychee-bin")
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output(bin/"lychee #{testpath}/test.md")
    assert_match "🔍 1 Total (in 0s) ✅ 0 OK 🚫 0 Errors 👻 1 Excluded", output
  end
end
