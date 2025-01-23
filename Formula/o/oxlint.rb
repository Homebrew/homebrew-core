class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v0.15.7.tar.gz"
  sha256 "f757bf9db7fc9d61f6c44c71c48e79f4f025347b187e860e790e3b0da393adc8"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1359b5a592d5c619f569a806c58203ae7bf3c2be81b2cb5815f6a841547a2323"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "473fbe04d5bda9d6854c85c699409242ccaead52dd4166ec5bc9decc8cd26bf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ea7785c44cb5257e367e5bcabaee1d7f228087d7db624a8a2b14b1429d2ec1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4339a6d70dc2ed09dbbce4a5fc63a23aa429211ac1176619a499fc06a21833fe"
    sha256 cellar: :any_skip_relocation, ventura:       "09dcf6df2ea667ad189e0ae6b0c09aae4b90171893f09547d21869b8e9eb2e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efb5e306c8eeda8bffe5715feb9ea28c033f654707793f9f8aba6351e8ac5fd8"
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
