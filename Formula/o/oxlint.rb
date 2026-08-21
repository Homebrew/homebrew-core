class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.79.0.tar.gz"
  sha256 "fc5b93330cc933c20f860168ef43ab1dc324510b8d393e3603620c8ee93294a6"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cbd4f322f97cd7c26971d410e58afa4f9d701a0c1c925071442bfb65226de70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2439085c02e0e8828f7cfd63b1d2da20fcae529671cec5d4762349dab208e895"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e58931c73adc65449619bdcee6c50016abe2eb01107b0a80cf9d28493acbf551"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9d5ae2560df3bbeca445f07b8894e429c164b84df11f4e367b3e42786cd97cf"
    sha256 cellar: :any,                 arm64_linux:   "3cb63ba6e398b01e2779553d6a2eb2a7ad59fdcbe6cde46cca4b210b6c4819a1"
    sha256 cellar: :any,                 x86_64_linux:  "419b342eebb9caf84e989598f9e06cebda60bb5e13d6250923e4d1833b4091ca"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
