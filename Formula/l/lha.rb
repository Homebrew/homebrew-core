class Lha < Formula
  desc "Utility for creating and opening lzh archives"
  homepage "https://github.com/jca02266/lha/"
  license "MIT"
  head "https://github.com/jca02266/lha.git", branch: "master"

  stable do
    url "https://github.com/jca02266/lha/archive/refs/tags/release-20211125.tar.gz"
    version "1.14i-ac20211125"
    sha256 "8761edac9613cf1c06cbc341259fb2abd804f8f5bb8ba25970779062701e8a46"

    # Backport fix for implicit-int
    patch do
      url "https://github.com/jca02266/lha/commit/a5c5d438537125bfe936ea523e7bc981a50364a2.patch?full_index=1"
      sha256 "73e34ffddbfeee0bcfe62e4d22de99ef5c54c07727c22da35e5bfc0970ad1297"
    end
  end

  # Tags simply use a date-based `release-YYYYMMDD` format, so we naively
  # prepend `1.14i-ac` to match the formula version format. This will need to be
  # updated if the leading version ever changes.
  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)*)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.prepend("1.14i-ac") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bee7819a0d02effd67fc7e781e8444ce69b45f6e6bcaf05ee8b47c0cc5a7d2fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e42f198ac84b3b9b7be6358792ecb7125de6f404def713744e7caac480afdf14"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7a59e14fef6de2726498fb18a67c4eab1361ca60563fddff7e98bb4cbd5b0ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b2b35c5e133e6d1e129bfe863a926d8f271c88572ed61b39da8fceabe072024"
    sha256 cellar: :any_skip_relocation, sonoma:         "41136df3dd0dda91fe8044b6d3478d410310a17bc9b7ac3f048de1279eaf433f"
    sha256 cellar: :any_skip_relocation, ventura:        "8b4acdd2bc29dadcc998d34d3fa8ce69f2d51b3de3c173d9e646b2c6fb8ea8a3"
    sha256 cellar: :any_skip_relocation, monterey:       "c502509c3aedc222e706f37ce333c2bb7ceaea113e21c8e7e06f19d3d4ed0cfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "350b62bf10fb130b75a0fa2e778e92e94e49e519385a59d9b6b1c128e78519ba"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  conflicts_with "lhasa", because: "both install a `lha` binary"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    system "autoreconf", "-fvi"
    system "./configure", "--mandir=#{man}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"foo").write "test"
    system bin/"lha", "c", "foo.lzh", "foo"
    assert_equal "::::::::\nfoo\n::::::::\ntest",
      shell_output("#{bin}/lha p foo.lzh")
  end
end
