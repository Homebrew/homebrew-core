class Perbase < Formula
  desc "Fast and correct perbase BAM/CRAM analysis"
  homepage "https://github.com/sstadick/perbase"
  url "https://github.com/sstadick/perbase/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "cd52449ef7ae4762effb577527a2f604f4ec20536b3550105104543535985949"
  license "MIT"
  head "https://github.com/sstadick/perbase.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "740472180a309e41e7783ea1a76acacaac2f251d637c5da7c2e1dc397c4efa64"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d3625d6f7852bf15c3621948bbcd77c5d7a32b3b7e0a43a11efacff3aedc67b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "399f25725f74e47913e2cd73d8bc37572c3739eff8e6f6cb9af579c123f0d4c5"
    sha256 cellar: :any,                 arm64_linux:       "80d11bb1187a0d1a508ab327d2548d69e687c32dcd2ea7bfc4a0370434df828e"
    sha256 cellar: :any,                 x86_64_linux:      "363a70a57f3e3f421663d937bcc1a6580517b7b09cfac18b936c04ab5f045dda"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "bamtools" => :test

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Resource to avoid building bundled libraries
  # Issue ref: https://github.com/rust-bio/hts-sys/issues/23
  resource "hts-sys" do
    url "https://static.crates.io/crates/hts-sys/hts-sys-2.2.1.crate"
    sha256 "fc7e68eb880b02c80cfb41e8dc7904062a3ea7e27b7c4556e88d648dd2f038da"

    livecheck do
      url "https://raw.githubusercontent.com/sstadick/perbase/refs/tags/v#{LATEST_VERSION}/Cargo.lock"
      regex(/name = "hts-sys"\nversion = "(\d+(?:\.\d+)+)"/i)
    end
  end

  deny_network_access!

  def fetch
    # Workaround to support newer LLVM
    hts_sys_version = File.read("Cargo.lock")[/name = "hts-sys"\nversion = "(\d+(?:\.\d+)+)/i, 1]
    odie "Remove `cargo update`!" if build.stable? && Version.new(hts_sys_version) >= "2.2.1"
    system "cargo", "update", "hts-sys", "--precise", resource("hts-sys").version.to_s

    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm") if OS.linux?

    # Workaround to disable building bundled zlib-ng in "gzp -> flate2"
    inreplace "Cargo.toml",
              /^(gzp = )("[\d.]+")$/,
              '\1{ version = \2, default-features = false, features = ["deflate_zlib", "libdeflate"] }'

    # Workaround to disable building bundled zlib-ng in "rust-htslib -> hts-sys".
    # Other bundled libraries are already disabled via "default-features = false"
    resource("hts-sys").stage(buildpath/"hts-sys")
    inreplace "hts-sys/Cargo.toml", /^features = \[\s*"zlib-ng",\s*"static",\s*\]$/, ""
    args = %w[--config patch.crates-io.hts-sys.path="hts-sys"]

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
