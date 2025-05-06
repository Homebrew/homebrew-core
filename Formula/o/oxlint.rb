class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v0.16.9.tar.gz"
  sha256 "32ae11a1708c629f066616fde90a64406e8a7a8288b68bd161ec5c234faad0f1"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f78d139a86a29f26f1e70a579705bdb9ba1dd35413de11a5ace3fac7554ac84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d866aa799b3f33316bab3421b6ab218272e38a627c0d60fe7d1a6d0557695b8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a7c72a2bbdb8713da51c0eaf5203096ac6c86e436d39430b3fba71e5177da13"
    sha256 cellar: :any_skip_relocation, sonoma:        "b153603757d8bd091caf7a42a61444f2b0797fc326495bae95b293924e3f0b28"
    sha256 cellar: :any_skip_relocation, ventura:       "208df123033fca0ef3881c6929c93a667a945cdf36e3479c0a4036af046e81c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a46306aadf8c8e3ed0fadba77c806fae50a1f4fb9901f723b6a646f1e8ada44f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f2fb4b9e8169ecd793818ed8afa452f05eb13881d148fe007effec01ab45468"
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
