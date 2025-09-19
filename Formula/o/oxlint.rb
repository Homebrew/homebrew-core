class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.16.0.tar.gz"
  sha256 "53fda71250a6fd37e7928510f6ec97de894e3dfdb0c959e3320eb9bd445b7654"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0d726454b63a287931adb025a9e208acc6f499375acd5b4e57d8bfdd58fac36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bf1375d47c30355fb2a99e421975a9259e1da14308b5d1dcf8857797cd2111a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "894059d25c8546e626ebd9ab0685ede0821e72e755802c8d0fa3a7dce2130585"
    sha256 cellar: :any_skip_relocation, sonoma:        "05f87745df29614cf5a6be4b22710b58dec94497612b4d8154f6078115a7a123"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c959606a94d2d0c8dc4bad42934c7cf476354de4d33478506ab2469de36f163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "897dec137037fef304cdc0ebc976dceb6e9a212128438103603857fb4d713a15"
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
