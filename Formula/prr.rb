class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https://github.com/danobi/prr"
  url "https://github.com/danobi/prr/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "b16132d1f2fe41f1a59f6bceaf6c85fd2773b9f20c8ae7bdbdc47b3998ad0b02"
  license "GPL-2.0-only"
  head "https://github.com/danobi/prr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "98e97d34660d02528349031507dced1f0d50321b6be3a39d419116901d2a8d22"
    sha256 cellar: :any,                 arm64_big_sur:  "47fd3d29b0281392d3d33f2ecf90c0435dd24d496764da704468b1e9570ef542"
    sha256 cellar: :any,                 monterey:       "5984f6cfce2650e40a7a56234b09299565f48f27930f8c6506a2693c7aa73ebd"
    sha256 cellar: :any,                 big_sur:        "5b893c94459f03b5498b00d3400c850b8f13203ec33f381297e27b4b75cba0d4"
    sha256 cellar: :any,                 catalina:       "86c5401d9a1df842fe1b49cc14b27dfd0d70c42ae9dcb72dfb164534ce98cfff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e89f3275ca5f24194e9fe32314d69e71d09ff5db46337a450cdb7c100fd36f39"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Failed to read config", shell_output("#{bin}/prr get Homebrew/homebrew-core/6 2>&1", 1)
  end
end
