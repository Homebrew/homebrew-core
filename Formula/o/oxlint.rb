class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.73.0.tar.gz"
  sha256 "afc0d18ff338129c77baa8f51e4a8de25d06e0e17048cd96204012b80f985f04"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1480ef66aa3eb2a89a724448040cc558cd6a24d0a89f271ea0eb789b8db3367"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f1137d201621a2567e3ecd7b319a9f4ca97e4df59d1dcabea6edad24b1ffc4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13f1918c6973abf9272c1094219c3b2077deb24c6e274641a6e1ad650be0deaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "150a850bdc913d816f4853727c3983247c5b7626b3492a05c2501689ff162a2c"
    sha256 cellar: :any,                 arm64_linux:   "ff55df9aa181a52111be4193e85ca0289980f58d75dab76b3103f9867cb9e5bf"
    sha256 cellar: :any,                 x86_64_linux:  "cf40dd94dfd2c489dceb9e1492aa2995b4c7ee56d6e3970747ca9f691f1b8ce1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars)::Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
