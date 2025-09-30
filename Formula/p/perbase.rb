class Perbase < Formula
  desc "Fast and correct perbase BAM/CRAM analysis"
  homepage "https://github.com/sstadick/perbase"
  license "MIT"
  head "https://github.com/sstadick/perbase.git", branch: "master"

  stable do
    url "https://github.com/sstadick/perbase/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "6b9e030ce0692631482ef074a7d6c37519d6400be21d2f7533ba44a0ec5dc237"

    uses_from_macos "xz" => :build
    uses_from_macos "curl"
    uses_from_macos "zlib"

    # Resource to avoid building bundled curl, xz and zlib-ng
    # Issue ref: https://github.com/rust-bio/hts-sys/issues/23
    resource "hts-sys" do
      url "https://static.crates.io/crates/hts-sys/hts-sys-2.1.1.crate"
      sha256 "deebfb779c734d542e7f14c298597914b9b5425e4089aef482eacb5cab941915"

      livecheck do
        url "https://raw.githubusercontent.com/sstadick/perbase/refs/tags/v#{LATEST_VERSION}/Cargo.lock"
        regex(/name = "hts-sys"\nversion = "(\d+(?:\.\d+)+)"/i)
      end
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eafb09895b546f68c784f9db1d04eccae19498a7dccf1a038e61f3383a32a34e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6381d9e4d8d9c0bf641a3c0584c8a6bce0915afe9eaf27a373a835222fbc0174"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80c024e6e5ef7a68dc49aff72115ed37123c19d145ec9b629b84fda0a3dd64b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "aca50eabad6b23d04cc9cf0cfb499dd80ceba95407039e389ec5c2bbca9c70c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48658dda19de513ad974dc716dc990aede00119881703453d584692f29d31c34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "070c89be5fd7eab9c163694a9f705fa7891dbe59168bd1f33327627c94e2f52f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "bamtools" => :test

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3" # need to build `openssl-sys`
  end

  def install
    if build.stable?
      # TODO: remove this check when bump-formula-pr can automatically update resources
      hts_sys_version = File.read("Cargo.lock")[/name = "hts-sys"\nversion = "(\d+(?:\.\d+)+)"/i, 1]
      odie "Resource `hts-sys` version needs to be updated!" if resource("hts-sys").version != hts_sys_version

      # Workaround to disable building bundled zlib-ng in "gzp -> flate2"
      inreplace "Cargo.toml",
                /^(gzp = )("[\d.]+")$/,
                '\1{ version = \2, default-features = false, features = ["deflate_zlib", "libdeflate"] }'

      # Workaround to disable building bundled curl, xz and zlib-ng in "rust-htslib -> hts-sys"
      resource("hts-sys").stage(buildpath/"hts-sys")
      inreplace "hts-sys/Cargo.toml" do |s|
        s.gsub!(/^features = \[\s*"static-curl",\s*"static-ssl",/, "features = [")
        s.gsub!(/^features = \[\s*"static"\s*\]$/, "")
        s.gsub!(/^features = \[\s*"zlib-ng",\s*"static",\s*\]$/, "")
      end
      args = %w[--config patch.crates-io.hts-sys.path="hts-sys"]
    end

    system "cargo", "install", *args, *std_cargo_args
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/test.bam", testpath
    system Formula["bamtools"].opt_bin/"bamtools", "index", "-in", "test.bam"
    system bin/"perbase", "base-depth", "test.bam", "-o", "output.tsv"
    assert_path_exists "output.tsv"
  end
end
