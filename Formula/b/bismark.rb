class Bismark < Formula
  desc "Bisulfite read mapper and methylation caller"
  homepage "https://github.com/FelixKrueger/Bismark"
  url "https://github.com/FelixKrueger/Bismark/archive/refs/tags/bismark-rust-v3.4.0.tar.gz"
  sha256 "f08d353a458932ab4b56c25ce556f1cbc3d321fb4f1ab4913688f96dabf0b491"
  license "GPL-3.0-only"
  head "https://github.com/FelixKrueger/Bismark.git", branch: "master"

  livecheck do
    url :stable
    regex(/^bismark-rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "4462c1568b74bedfa8027d663901b6f69c89bc71541bfd2562b0d6734ed110ee"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4b868ab1ed75851d2cd37f2ee34ebbfe1e0571b9e446c3bec45d443028639241"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a1ce574fc1c062df2112d51815d2d214117d58101656b0f0373715955821952b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3123b9b06e867451b6521f69c4805f5f2a8777de941f3e70e0e731ae11a32612"
    sha256 cellar: :any,                 arm64_linux:       "f88d96cd6e8c66a91fe8b7ad9bb29eec195a368af1e0c8f1ea021e5892c2da81"
    sha256 cellar: :any,                 x86_64_linux:      "86a59d8eca54a24a6c1d80d7aa7cfada1858774d461cba08f5ca650fc6454197"
  end

  depends_on "rust" => :build
  depends_on "bowtie2"
  depends_on "minimap2"

  deny_network_access!

  def fetch
    cd "rust" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/bismark")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bismark --version")

    (testpath/"genome/chr.fa").write ">chr\n#{"ACGTACACGTGTACGT" * 40}\n"
    system bin/"bismark_genome_preparation", testpath/"genome"
    assert_path_exists testpath/"genome/Bisulfite_Genome"
  end
end
