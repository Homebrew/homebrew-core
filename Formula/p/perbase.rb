class Perbase < Formula
  desc "Fast and correct perbase BAM/CRAM analysis"
  homepage "https://github.com/sstadick/perbase"
  license "MIT"
  revision 1
  head "https://github.com/sstadick/perbase.git", branch: "master"

  stable do
    url "https://github.com/sstadick/perbase/archive/refs/tags/v1.4.0.tar.gz"
    sha256 "fc0d08964950381969a1cf12e1e1e39eb8edde26794b8d653e7d80b08180fc43"

    uses_from_macos "xz" => :build
    uses_from_macos "curl"

    on_linux do
      depends_on "zlib-ng-compat"
    end

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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "53702bb86d29e3daab44e8e55c37d5e464ed13a7dfb32099f7472b18f0fd825b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cce60fe3ecdecc42c1f32e50d8b2b92a2d7bc10c3db98672242e8dd899b32b35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d554f19a1b85a4b7c80645c90aec890ede85b84339b8b377a4ae42f0fe97b130"
    sha256 cellar: :any,                 arm64_linux:       "787079ab44a87f56b95c0899097aa0b3f8d2b97214087afca2bdb4e6af610ae4"
    sha256 cellar: :any,                 x86_64_linux:      "828188f82f7f51c5e27838b65b1d140eaf008a7ac3abad455ee44dd4770a5900"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "bamtools" => :test

  uses_from_macos "bzip2"

  on_linux do
    # FIXME: bindgen 0.69 (via rust-htslib 0.51) generates opaque structs with libclang 22+
    depends_on "llvm@21" => :build # for `libclang`
  end

  def install
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm@21") if OS.linux?

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
    system formula_opt_bin("bamtools")/"bamtools", "index", "-in", "test.bam"
    system bin/"perbase", "base-depth", "test.bam", "-o", "output.tsv"
    assert_path_exists "output.tsv"
  end
end
