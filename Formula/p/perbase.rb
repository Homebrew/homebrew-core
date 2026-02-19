class Perbase < Formula
  desc "Fast and correct perbase BAM/CRAM analysis"
  homepage "https://github.com/sstadick/perbase"
  license "MIT"
  head "https://github.com/sstadick/perbase.git", branch: "master"

  stable do
    url "https://github.com/sstadick/perbase/archive/refs/tags/v1.4.0.tar.gz"
    sha256 "fc0d08964950381969a1cf12e1e1e39eb8edde26794b8d653e7d80b08180fc43"

    uses_from_macos "xz" => :build
    uses_from_macos "curl"
    uses_from_macos "zlib"

    # Resource to avoid building bundled curl, xz and zlib-ng
    # Issue ref: https://github.com/rust-bio/hts-sys/issues/23
    resource "hts-sys" do
      url "https://static.crates.io/crates/hts-sys/hts-sys-2.2.0.crate"
      sha256 "e38d7f1c121cd22aa214cb4dadd4277dc5447391eac518b899b29ba6356fbbb2"

      livecheck do
        url "https://raw.githubusercontent.com/sstadick/perbase/refs/tags/v#{LATEST_VERSION}/Cargo.lock"
        regex(/name = "hts-sys"\nversion = "(\d+(?:\.\d+)+)"/i)
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b27f4cd506f89c3822aa14588869b38b370dad2b9c4a054263d3c12765c00c9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a1c6d4c2ae40f87cc7a785ffb31f0d64da26369ca813ebd1dc8ebcf9b33cd1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dd7e81330143f8e68f14c8188b3616571a1f2f55da6c64bc349b56b3e80bbbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "cab8cc6d3e4cd2c64c8895b23ecd4b1021151d6ce3b94e3bc74b650c0430a473"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29544aef879ded62af4a4c9344507a18d5e49fb430b05d0e7284180960ac8d34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97139d275264bcab4fc057f2e7e4fa2cdf187f73bfbd3e438956ff137151d026"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "bamtools" => :test

  uses_from_macos "bzip2"
  uses_from_macos "llvm" # for `libclang`

  on_linux do
    depends_on "openssl@3" # need to build `openssl-sys`
  end

  def install
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib if OS.linux?

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
