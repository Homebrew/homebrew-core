class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "185445dd81f0038778f23a90f573906b5697b3e99d572fb7727882c9c71236d8"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3e9b10aae0d0ed4d4a803eef4db9ecedf541c132848433f8654bb366118d4d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3e9b10aae0d0ed4d4a803eef4db9ecedf541c132848433f8654bb366118d4d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3e9b10aae0d0ed4d4a803eef4db9ecedf541c132848433f8654bb366118d4d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "37129d0c9f868a63b92d77d13fc21738755ae3b215cdf1b843b7e4d28579d626"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70713de0a19eaed153a5b86aa34afa70a634b546cbc5ff4fb9465dad40131c4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c729a1716ed2fa446f36565b2837538a6708af33f682b59c3b18bc998dc9dd3"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/moor"

    # Hint for moar users to start typing "moor" instead
    bin.install "scripts/moar"

    man1.install "moor.1"
  end

  test do
    # Test piping text through moor
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moor test.txt").strip
  end
end
