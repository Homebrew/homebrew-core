class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-2.0.1.tar.gz"
  sha256 "2f79d50c3eb8301c8bde8b86e1071c31ea9387373077302ffbf387df63477c48"
  license "MIT"
  head "https://g.blicky.net/ncdu.git", branch: "zig"

  livecheck do
    url :homepage
    regex(/href=.*?ncdu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c64a0d0632324546644eeea92b3602c575f03d78deb2683322ee717a3c26d7dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3701146877931592e1ee5da09419d9b8c1468690c8299e24e00aa1eb6ef11b1"
    sha256 cellar: :any_skip_relocation, monterey:       "72aa728cdb6c1b026904b7aaba4aba29b50685ad4c34607e06b895b42a8811af"
    sha256 cellar: :any_skip_relocation, big_sur:        "987d1cb26e3f342d0f812eb14fc325da3db2d18f81695a7b992f643eae4ea6be"
    sha256 cellar: :any_skip_relocation, catalina:       "37ec98781ed0c2391d5a402a0f8421c9c7d2afd5f9101e390b336ff580f31de8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "826b3f78320617d3b30d7400a768572e1fe315e8b59a60295995a7de7b563941"
  end

  depends_on "pkg-config" => :build
  depends_on "zig" => :build
  uses_from_macos "ncurses"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[--prefix #{prefix} -Drelease-fast=true]
    args << "-Dcpu=#{cpu}" if build.bottle?

    # Avoid the Makefile for now so that we can pass `-Dcpu` to `zig build`.
    # https://code.blicky.net/yorhel/ncdu/issues/185
    system "zig", "build", *args
    man1.install "ncdu.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncdu -v")
    system bin/"ncdu", "-o", "test"
    output = JSON.parse((testpath/"test").read)
    assert_equal "ncdu", output[2]["progname"]
    assert_equal version.to_s, output[2]["progver"]
    assert_equal Pathname.pwd.size, output[3][0]["asize"]
  end
end
