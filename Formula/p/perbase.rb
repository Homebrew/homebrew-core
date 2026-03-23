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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db301d59e5776cf75acdcd7d68d003d8079214e14e0ff919f7762def827a6404"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9eb5021cc0e1b266849709483bcb0e19cf92ef262e2e3efe46e1d460801ed4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48e46a4060863bfb3ac7d4949e549e49fc0dd8952a2fa46ee2ea7db0f80bcae1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4221dcf8ff76d7104dd2facef196f88ded3ca23240fd7a8ec674c1ca07f2b2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bed582fbd2dac3de2d846a82b1bb543b1a745f2c741709715e84ebbbab1e417b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad1e22315efecbf08511298c1e24a6b48c489ad3a1ee7006ee287e2d23caffe5"
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
