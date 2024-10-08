class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v0.9.10.tar.gz"
  sha256 "d50ec9a95c6cf5e10b49a645bcb93430a286e09ffbb59e9ae8883b163169e4c1"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59b82ee277aaf8bf580caa78044f6be73155994f0558f793a894b379abe59993"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af29e0def0e775cb4015a49d309e97a02b8e5c13a605f5b939aae82a3ef419d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bcd9432126ffa83c7fef172e86cc3dc23779427e5f2ea60297c3da48948b9e8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dda034ff652360361a9a4fda3de82c497b1a3e59a09b0aa80e8fab52f51cbfc"
    sha256 cellar: :any_skip_relocation, ventura:       "4b2fbe03e25633a92ffb4c49884db3c0fbcb0a3f7bc1d9713604364370b56f6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26160820b40f5615c379b9cadf0868769d37bfd744804db400a7757eb4d616ca"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
