class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-2.0.tar.gz"
  sha256 "66cda6804767b2e91b78cfdca825f9fdaf6a0a4c6e400625a01ad559541847cc"
  license "MIT"
  revision 1
  head "https://g.blicky.net/ncdu.git", branch: "zig"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55eb407cd2f1cdb3ba6e13c7d8b201a261bd35edd146a0d2464b652c2256fd1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51ff65b2939cb4869696821685d533ce332f8107fec25c7a6584881f1459448d"
    sha256 cellar: :any_skip_relocation, monterey:       "f8699b3b9b9a9c292eb93583dad97b9d4ceeefd7e6fbf4c8525cbfa3cc08e21b"
    sha256 cellar: :any_skip_relocation, big_sur:        "500e070b5d64261035b16ab91d164952f282db7616f8e17c1c4f5e8b2b8a8b3b"
    sha256 cellar: :any_skip_relocation, catalina:       "0a782ed37f28f1104e1ad8aa94272819e8f53cf3602b3ab949642fc9bf537903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3527f58dc6bd833572043f4867ee9d51884eac64a36fe49b2ca78ad4195c181f"
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
