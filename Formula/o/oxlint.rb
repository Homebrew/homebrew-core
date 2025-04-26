class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v0.16.7.tar.gz"
  sha256 "8897d89d5d8ae9d30906f579225fd0e86ed5bca668693f7e454d185ffb5475f4"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47c951bb847e430763f52fe35e1fbd873bb80024847d220c08fec6e093d6fb14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edc4e05d207690fbf2eff992f6befd507e5ea16f6618adcc993a94020a6a3c4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "69667e9966468f680bfb91cd6e178495d8c216244e8531e73d45bbed138feefb"
    sha256 cellar: :any_skip_relocation, sonoma:        "181bfda5b579e81d773ebc70d3fa76ccd290332cbec5c809e5fe3914313085ee"
    sha256 cellar: :any_skip_relocation, ventura:       "11cb6377b06e5017c3d921a3d54d12a4da5200e07e1786ebe601065638c8c3ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcc528375e15af4bcd54213eb90f14c7ca706fdd9c26c1bbf06028866760a03e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b8aa871c3471982c12e9a66eefb8b6108a629880c5879b95fc8bb30a4797e45"
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
