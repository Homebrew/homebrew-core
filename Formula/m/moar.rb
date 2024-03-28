class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.23.9.tar.gz"
  sha256 "0e88ff31268ba143e3c59e64751b16c720377c18afa257e2555a8c40ff66f69d"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "807c7983e5e6c3edcddf3b063dc9f2a1a00457dd03560a6ffc3f1684a37907fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "807c7983e5e6c3edcddf3b063dc9f2a1a00457dd03560a6ffc3f1684a37907fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "807c7983e5e6c3edcddf3b063dc9f2a1a00457dd03560a6ffc3f1684a37907fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "794cd7000f5d9e3013f68117511a130067509ab095cb01c5c4761ea3a25cbf40"
    sha256 cellar: :any_skip_relocation, ventura:        "794cd7000f5d9e3013f68117511a130067509ab095cb01c5c4761ea3a25cbf40"
    sha256 cellar: :any_skip_relocation, monterey:       "794cd7000f5d9e3013f68117511a130067509ab095cb01c5c4761ea3a25cbf40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2acbd7ec2747fdf31d90d5b6c709ad18a903185bde0b591e414b7ed494eaee29"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
