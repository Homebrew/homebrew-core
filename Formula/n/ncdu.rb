class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-2.4.tar.gz"
  sha256 "4a3d0002309cf6a7cea791938dac9becdece4d529d0d6dc8d91b73b4e6855509"
  license "MIT"
  head "https://g.blicky.net/ncdu.git", branch: "zig"

  livecheck do
    url :homepage
    regex(/href=.*?ncdu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "10de74d4c9b0e950712a13e2f1b08ebc59abf6e68306a9e5e3d1fb452cc6127b"
    sha256 cellar: :any,                 arm64_ventura:  "beeb416eb7033954b972e34c883997949fb39d30c616d7d8f112e94e5c0cad9a"
    sha256 cellar: :any,                 arm64_monterey: "e33bab1bfa37760234049cb7ba9fa2e66b58dd7da22fc1a657ec04215a74723e"
    sha256 cellar: :any,                 sonoma:         "d9798da4a4ac01005a01428d421d4fee7b4680a8cc22d70322e193aa88cc1203"
    sha256 cellar: :any,                 ventura:        "1766460676314d7c3ea2800fcd653d3eeab53d22a168d80eca343a219dbc2ff9"
    sha256 cellar: :any,                 monterey:       "9e1560f5ec4857297172f51520a77882c547f77928f61e9a11b503cd3ae5e948"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9158a5626debef36c3e146f48f30a5ad5088ee9d0920f71119fa4e38ced25175"
  end

  depends_on "pkg-config" => :build
  depends_on "zig" => :build
  # Without this, `ncdu` is unusable when `TERM=tmux-256color`.
  depends_on "ncurses"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[--prefix #{prefix} --release=fast]
    args << "-Dpie=true" if OS.mac?
    args << "-Dcpu=#{cpu}" if build.bottle?

    # Workaround for https://github.com/Homebrew/homebrew-core/pull/141453#discussion_r1320821081
    # Remove this workaround when the same is removed in `zig.rb`.
    if OS.linux?
      ENV["NIX_LDFLAGS"] = ENV["HOMEBREW_RPATH_PATHS"].split(":")
                                                      .map { |p| "-rpath #{p}" }
                                                      .join(" ")
    end

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
