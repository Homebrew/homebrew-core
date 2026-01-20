class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxfmt_v0.26.0.tar.gz"
  sha256 "0b05bc8c8cd9732552aaf6f0fd2b97764c4f1603789dd96a2ce3e4ba59790a88"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxfmt_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "175106716eb50a0d1887f7f951eee7d8ec2fbade8440107ce62626a8530c1093"
    sha256 cellar: :any,                 arm64_sequoia: "2bbab8f68615ed311413f54de42cd0a8c7d37d918438e6ed85e01f8737acf4fc"
    sha256 cellar: :any,                 arm64_sonoma:  "2bbab8f68615ed311413f54de42cd0a8c7d37d918438e6ed85e01f8737acf4fc"
    sha256 cellar: :any,                 sonoma:        "1fab0a4155d9ae7959c59d49256a329b5868f46d998a3e6a3acfe2d04f20f6a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d067e748e21d63af3284052138c944229bdd82f2e53df11f7a4d10984773ac1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "649e62711c2bbda7d5b7930c410ad4790c4d623b908bc0d6fd9d03485c122dbe"
  end

  depends_on "rust" => :build

  def install
     system "cargo", "install", *std_cargo_args(path: "apps/oxfmt")
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"oxfmt", "test.js"
    assert_equal "const arr = [1, 2];\n", (testpath/"test.js").read
  end
end
