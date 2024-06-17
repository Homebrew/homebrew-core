class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "38fa9db4e6d2ad1dfe533acd26c12a56b5940ae3ec4d57fee927b6bc9d223359"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cfc44253211c3a064db67172b6eed65b1ba23d4fdf4ca771b3f0ed50fa4cb35a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56ef353256d7fa0fce260f2758e760ffe82597689c10f52781bb4ac6f74d80d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fab2f157d25f70e0f716fa75efa0e13af636f62ed069668cf086295554b3466"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7ab93148d5f2dad49942c2513df7762ca6914f79f1e8e93b63cf0ff8d4d1904"
    sha256 cellar: :any_skip_relocation, ventura:        "82542a58c486ea7885fcf627a893d1b4bd95de007bb0f9f0f41b0f782e727d29"
    sha256 cellar: :any_skip_relocation, monterey:       "d267f026d230ef44a9f1ae8b1ecb6c6d4ac28f9863bb187eb4c2bc60b19280d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "696ec11c8a3becb879b482a6e3ef9f2f478c3a75366c0c63a46e4834982e7c5d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/pdfcpu/pdfcpu/pkg/pdfcpu.VersionStr=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pdfcpu"
  end

  test do
    info_output = shell_output("#{bin}/pdfcpu info #{test_fixtures("test.pdf")}")
    assert_match <<~EOS, info_output
      installing user font:
      Roboto-Regular
      #{test_fixtures("test.pdf")}:
                    Source: #{test_fixtures("test.pdf")}
               PDF version: 1.6
                Page count: 1
                Page sizes: 500.00 x 800.00 points
    EOS

    assert_match "validation ok", shell_output("#{bin}/pdfcpu validate #{test_fixtures("test.pdf")}")
  end
end
