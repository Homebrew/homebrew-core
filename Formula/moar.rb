class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "3073f3d086ec7a9980b2a9db6e3500233e99626c5c3deec21c3f149199d96b40"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98d564ab183e0d94eccf315b1d4820518e1431f12d009a9cb2bee16b606085f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98d564ab183e0d94eccf315b1d4820518e1431f12d009a9cb2bee16b606085f0"
    sha256 cellar: :any_skip_relocation, monterey:       "d62aa6c2b2d9af3c1a30099c2a00016c1c1d1188c62259cbb6944138ecb1b3cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "d62aa6c2b2d9af3c1a30099c2a00016c1c1d1188c62259cbb6944138ecb1b3cd"
    sha256 cellar: :any_skip_relocation, catalina:       "d62aa6c2b2d9af3c1a30099c2a00016c1c1d1188c62259cbb6944138ecb1b3cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56952392351b3b078844bbb1d5147fcbec1d7c11d0437285ac6239feb44ac48a"
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
