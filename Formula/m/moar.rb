class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.23.5.tar.gz"
  sha256 "f3c1c88545afde91d685943db20be1ae003b15c855faed9db61377f2dc768f4f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7977728a3d019fdc29d059e9e746733f9c0cc7d2eae7db99ff66cb8b4a03ffe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7977728a3d019fdc29d059e9e746733f9c0cc7d2eae7db99ff66cb8b4a03ffe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7977728a3d019fdc29d059e9e746733f9c0cc7d2eae7db99ff66cb8b4a03ffe"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e2995af9bcbc59248c0d458bce644d55b259bbbe6aa23b3c8ab7449950d7bc0"
    sha256 cellar: :any_skip_relocation, ventura:        "3e2995af9bcbc59248c0d458bce644d55b259bbbe6aa23b3c8ab7449950d7bc0"
    sha256 cellar: :any_skip_relocation, monterey:       "3e2995af9bcbc59248c0d458bce644d55b259bbbe6aa23b3c8ab7449950d7bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fde3c844529c0a496dbf7b054c3664d022e0a155ac0d07ae4970e6eba183d3b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
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
