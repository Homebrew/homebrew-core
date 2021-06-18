class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "f4edbca2cce46e64d033536958d813ed70e7668ab52316cb87e42cccdb00eaaf"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "86db9d59c47d9b96c145895ee212e43a2db9114cc60797996a046f2ac92e4053"
    sha256 cellar: :any_skip_relocation, big_sur:       "d521a4923cde3e7834bbc4daf247125a3a2d3fa30fe2a72f969c3bde51e588b8"
    sha256 cellar: :any_skip_relocation, catalina:      "d521a4923cde3e7834bbc4daf247125a3a2d3fa30fe2a72f969c3bde51e588b8"
    sha256 cellar: :any_skip_relocation, mojave:        "d521a4923cde3e7834bbc4daf247125a3a2d3fa30fe2a72f969c3bde51e588b8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
