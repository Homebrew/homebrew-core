class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.23.15.tar.gz"
  sha256 "d2edfc143eb3c71ea1ce51753b60da19f907013a16649ff81cd42cb7e3b3835b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8394e637a9e4ce94733a9870f0b66fb0f0f1ae8903f57bb0200de115d0a032c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8394e637a9e4ce94733a9870f0b66fb0f0f1ae8903f57bb0200de115d0a032c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8394e637a9e4ce94733a9870f0b66fb0f0f1ae8903f57bb0200de115d0a032c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "827808e4f26a7ec00b33054f91b5a2a3719d8d706d5baefce0d9bc9f0500e392"
    sha256 cellar: :any_skip_relocation, ventura:        "827808e4f26a7ec00b33054f91b5a2a3719d8d706d5baefce0d9bc9f0500e392"
    sha256 cellar: :any_skip_relocation, monterey:       "827808e4f26a7ec00b33054f91b5a2a3719d8d706d5baefce0d9bc9f0500e392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51d71ac4008afcf7ae44cf5732e372fff6e3bae3a46bf0dc201052582cc71214"
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
