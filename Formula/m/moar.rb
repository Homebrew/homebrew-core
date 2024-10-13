class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.27.2.tar.gz"
  sha256 "c1aa0c217dd5b59535b0cbe6b0a6e02a14cdff01bbe2146ea1b0968036c9a412"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8b2fe002af52128a8b2fee5d0c85e69845d97bbb44bfa4aba08543ea72e8599"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8b2fe002af52128a8b2fee5d0c85e69845d97bbb44bfa4aba08543ea72e8599"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8b2fe002af52128a8b2fee5d0c85e69845d97bbb44bfa4aba08543ea72e8599"
    sha256 cellar: :any_skip_relocation, sonoma:        "9996d9c346df96536d64d24a768cc8784666907a8e38bd97782c3681b3f185eb"
    sha256 cellar: :any_skip_relocation, ventura:       "9996d9c346df96536d64d24a768cc8784666907a8e38bd97782c3681b3f185eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fde48d67ac5c4564882e843240c57bedc898b175532c812da84c7528bcadafeb"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

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
