class Icon < Formula
  desc "General-purpose programming language"
  homepage "https://www.cs.arizona.edu/icon/"
  url "https://github.com/gtownsend/icon/archive/v9.5.23a.tar.gz"
  version "9.5.23a"
  sha256 "0c2e8b70a19e476c7a5a4aaaa46160f2f6197d14d6f8e01e164b6a3fff8c210a"
  license :public_domain

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96ab681e8b11b84c91341c9e26a9e62bd06d46628a34ae82feb6667d60558a5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46c07df0ca96d6e542ca60a408033a6a2028452bab870ea9d2d2d8c491e13548"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45f71cd63309a5a437ee540298cd1a4e4cfa0fd29b053f92adea1629a3aac410"
    sha256 cellar: :any_skip_relocation, ventura:        "44bea37decf07d99d970287f3f5362e3d7fec53bb789369b66dd9217ff454a8a"
    sha256 cellar: :any_skip_relocation, monterey:       "ce826fdbdec5d74f7d874f1a751744be35f0cbd0d2bdd7aca2407fed819bb2aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "27fb48cd05938d4c0952659d66768e9828126dc83c839ee795c3f446263c033f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71876d0cb174f898273ea8bce7de8bf6a3078dafa5394c1bab9c3b8912663d43"
  end

  def install
    ENV.deparallelize
    target = if OS.mac?
      "macintosh"
    else
      "linux"
    end
    system "make", "Configure", "name=#{target}"
    system "make"
    bin.install "bin/icon", "bin/icont", "bin/iconx"
    doc.install Dir["doc/*"]
    man1.install Dir["man/man1/*.1"]
  end

  test do
    args = "'procedure main(); writes(\"Hello, World!\"); end'"
    output = shell_output("#{bin}/icon -P #{args}")
    assert_equal "Hello, World!", output
  end
end
