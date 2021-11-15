class Bgrep < Formula
  desc "Like grep but for binary strings"
  homepage "https://github.com/tmbinc/bgrep"
  url "https://github.com/tmbinc/bgrep/archive/bgrep-0.2.tar.gz"
  sha256 "24c02393fb436d7a2eb02c6042ec140f9502667500b13a59795388c1af91f9ba"
  license "BSD-2-Clause"
  head "https://github.com/tmbinc/bgrep.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c65ddc4ca486db177cd63f45e4cb97172f590ed9b2f70364120b2326e7ab3f94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d5628a1b93a4ad2e770502b011140bc301051e1679ac5d59eadbd9b94944b1b"
    sha256 cellar: :any_skip_relocation, monterey:       "2264b9b3c17b3faa5c66f612ce460a65e02bf0f3c3620002c90866c699b5cf81"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbd5d550e042d764f0cc4c39e58cd40ae87430fb773aae7d77f3ca56d05c3325"
    sha256 cellar: :any_skip_relocation, catalina:       "444a8dd0c2190e3a75574f8bee287895aee1d070d3e72e72fd7cda4c9cb77211"
    sha256 cellar: :any_skip_relocation, mojave:         "8a3633a884feda24b875005550fddbd613987c89edc9418dd23783b4c2f7e8af"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c2357ea00756425fec65d8367e7b8653a4d6845b6aa044106b8952d8b8ead0ca"
    sha256 cellar: :any_skip_relocation, sierra:         "eaed7c05fd07c77cd5aeb6f1232abcf5c9678b86fdaf7e7daf5049476acc690c"
    sha256 cellar: :any_skip_relocation, el_capitan:     "29f0b2d7ab307eae228a03d4f42f677d9ff0884edc5c96771da36182cb592cd2"
    sha256 cellar: :any_skip_relocation, yosemite:       "af4dab94130c48930d064074da8492c5531842a348747b0dd39420db738f6ae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5a19c037fcdd2ef3d50b419dd0d80208febfe24fb6bf785f40f47b7b2f87f45"
  end

  def install
    args = %w[bgrep.c -o bgrep]
    args << ENV.cflags if ENV.cflags.present?
    system ENV.cc, *args
    bin.install "bgrep"
  end

  test do
    path = testpath/"hi.prg"
    path.binwrite [0x00, 0xc0, 0xa9, 0x48, 0x20, 0xd2, 0xff,
                   0xa9, 0x49, 0x20, 0xd2, 0xff, 0x60].pack("C*")

    assert_equal "#{path}: 00000004\n#{path}: 00000009\n",
                 shell_output("#{bin}/bgrep 20d2ff #{path}")
  end
end
