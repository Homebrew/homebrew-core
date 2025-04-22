class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://lychee.cli.rs/"
  url "https://github.com/lycheeverse/lychee/archive/refs/tags/lychee-v0.18.1.tar.gz"
  sha256 "f04f4cd3dc2ac190a5d28134362e9ea44409013ab372086dbe2c73792dc4b462"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cca5846ef8febbb417f1fcb9cd1d28dd43c1cefb2a565eaa791d2219a9bef958"
    sha256 cellar: :any,                 arm64_sonoma:  "39793095082c16fe8e10a056f059ab0a4e8859cc9c65c9db3f79fc8bddc4f149"
    sha256 cellar: :any,                 arm64_ventura: "94c85e54bdd71f1764c33c11a6ee4b9b19bba527bf59492e932aae02868a285d"
    sha256 cellar: :any,                 sonoma:        "fb140a3ad491c505eefb9ce6b077d86b489cf6f1bc9d409aaf1a589a88d743b7"
    sha256 cellar: :any,                 ventura:       "7a13344d2c35163a49407c26ba58e3c740b4c0951711c11e375d15407fc26a23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b21cc1f26204144b8b40601878203f137b906eb561db96d52067862c2558935f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0e41b80889f77ca79c1865b7cd8f9d588d4f9d2954fd3da559f6a982dc87e60"
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
