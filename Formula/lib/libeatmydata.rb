class Libeatmydata < Formula
  desc "LD_PRELOAD library and wrapper to transparently disable fsync and related calls"
  homepage "https://www.flamingspork.com/projects/libeatmydata/"
  license "GPL-3.0-or-later"
  head "https://github.com/stewartsmith/libeatmydata.git", branch: "master"

  stable do
    url "https://github.com/stewartsmith/libeatmydata/releases/download/v131/libeatmydata-131.tar.gz"
    sha256 "cf18a8c52138a38541be3478af446c06048108729d7e18476492d62d54baabc4"

    # Fix for https://github.com/Homebrew/homebrew-core/issues/136873.
    # Remove with `stable`` block on next release.
    patch do
      url "https://github.com/stewartsmith/libeatmydata/commit/ae89d0916c0ddd06f4ce7f2b37eaccf8dd543591.patch?full_index=1"
      sha256 "8bf4249f3df141fa321c8c64af4f4442bc23bdfb108e2cf73c22e68a3a71ae15"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "b3541c1127dc057cc98e54fe64f65e7cea63040258b7d8dd33dcaa99cdd2f9bc"
    sha256 cellar: :any,                 arm64_sequoia: "1d20eb672c446fa9b5c6f44e1f75a165f23b993be2f11ae203e5fe7a4d9a20ec"
    sha256 cellar: :any,                 arm64_sonoma:  "75e170239996c79f9dd99439c460f42b7b902cb387d140bddaf5c824b88ab243"
    sha256 cellar: :any,                 arm64_ventura: "91c07ca49009f2bd4e377efedf459a536d491c4250d06ece93fe63356a045bcc"
    sha256 cellar: :any,                 sonoma:        "e5194f70fa35da7d6a2a199db97928ab5650c731cfb5235407ff464442bfe757"
    sha256 cellar: :any,                 ventura:       "08c627a35daeae1fe9602ad44723640b8328485bb05ed832fce245060de86ba4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b06012e7f311dcfc040049a34b63d7766c0d965f3348175d93fccb5753995a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc9b82e66d7d882d3a2b5579fcd31040feab74d5b6a333d1060b02a695fe8eca"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_monterey :or_older do
    depends_on "coreutils"
  end

  on_linux do
    depends_on "strace" => :test
  end

  def install
    # macOS before 12.3 does not support `readlink -f` as used by the `eatmydata` shell wrapper script
    if OS.mac? && MacOS.version <= :monterey
      inreplace "eatmydata.sh.in", "readlink", "#{Formula["coreutils"].opt_bin}/greadlink"
    end

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-option-checking",
                          "--disable-silent-rules",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"eatmydata", "sync"
    return if OS.mac?

    output = shell_output("#{bin}/eatmydata #{Formula["strace"].opt_bin}/strace sync 2>&1")
    refute_match(/^[a-z]*sync/, output)
    refute_match("O_SYNC", output)
    assert_match(" exited with 0 ", output)
  end
end
