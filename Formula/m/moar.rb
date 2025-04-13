class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.31.4.tar.gz"
  sha256 "055d18ec7fca693dc99d69c0a2dc43e4b897dceddcf58c03959b0ad0f3c3faf7"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c084a008cef6178613047de56baed416d84457ce4d7adea780936632d5d1315"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c084a008cef6178613047de56baed416d84457ce4d7adea780936632d5d1315"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c084a008cef6178613047de56baed416d84457ce4d7adea780936632d5d1315"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c961b26938296350aace89a192a0e0f8fd093a0dbd4ff5e10c319b3339b99b1"
    sha256 cellar: :any_skip_relocation, ventura:       "0c961b26938296350aace89a192a0e0f8fd093a0dbd4ff5e10c319b3339b99b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f69a66b3bede04067bcd3bcb2fa7a96c8e3f7b60948dd92f9c337498ba7a25cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b334983c5ba2b7de6ecef83e1aa3355bd17a3858770d8d80c915667f8103633"
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
