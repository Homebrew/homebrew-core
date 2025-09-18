class Lutgen < Formula
  desc "Blazingly fast interpolated LUT generator and applicator for color palettes"
  homepage "https://ozwaldorf.github.io/lutgen-rs/"
  url "https://github.com/ozwaldorf/lutgen-rs/archive/refs/tags/lutgen-v1.0.1.tar.gz"
  sha256 "12923b00a23dc6a9b871e1be1fda266254dca679698ae32957d0c454ef78518a"
  license "MIT"
  head "https://github.com/ozwaldorf/lutgen-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:lutgen[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "693dc106ab4fff5ba6fa4b9fe839f29f43d859af36e668acf74148ff224ad6fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c0b1bd19b9686ac431177bbd165b84746d8fc042f1b4f49c6477f324322e5c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31475c3367b81ee4d8f2ebf3add6d74cb3f0e11f335ac68e646d4e3ea0543d88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf858f29005837f1a9162dae7f68b392630e241eaabef69960c5cb0c85bf655a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d64054fa7a6b3658ea510612991dd13ee760d3d93bbfb683767515b07c4756df"
    sha256 cellar: :any_skip_relocation, ventura:       "44d32680156c61f5a11c5aaffe4bd4ca97a88079db8c800919a02919a5fdc6a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40b2f313af315693b1444a60b7625109803f2f2ae5510e3560b861d0d96a4728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4553254a230bc178d676685b13c386452c3c45eb1f17b4b1523638dfb69819e7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lutgen --version")

    cp test_fixtures("test.png"), testpath/"test.png"
    system bin/"lutgen", "apply", "--palette", "gruvbox-dark", "-o", "result.png", "test.png"
    assert_path_exists testpath/"result.png"
  end
end
