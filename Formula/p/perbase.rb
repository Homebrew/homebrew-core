class Perbase < Formula
  desc "Fast and correct perbase BAM/CRAM analysis"
  homepage "https://github.com/sstadick/perbase"
  license "MIT"
  head "https://github.com/sstadick/perbase.git", branch: "master"

  stable do
    url "https://github.com/sstadick/perbase/archive/refs/tags/v1.2.0.tar.gz"
    sha256 "35b35573e48e5af17d953e66d345c5e8b2ea69bb072e5bbaff87adbfc02cb472"

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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0636431f82c8954c63cde109db5836e5e6e15eb184d8bd27a7903e309cce9c60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb08705eac22818c85049618ac85b7c2f9d426791b6f4335cb2f3f9f072ecf08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a111ce2213e482f9a6c1455868a16f1468f131447c4b1faa47b8b27995480b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8a6a7e3ffaef9e99a7031f89bd2a2fefe1f70b066f95114f2233d024f7b96bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0adff209fb65737baa373c804ad1d5fd1b3fef82fd666b12e814070fd7fd1f3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ce57814f35a422bd640d24d830c988e273b21c141411c7f5f9939f54becf812"
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
