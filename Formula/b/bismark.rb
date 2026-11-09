class Bismark < Formula
  desc "Bisulfite read mapper and methylation caller"
  homepage "https://github.com/FelixKrueger/Bismark"
  url "https://github.com/FelixKrueger/Bismark/archive/refs/tags/bismark-rust-v3.2.0.tar.gz"
  sha256 "8b7261a2071a7c73e7b7e0337c243da126aacdb4feb526cac0d1d6a3431b65e5"
  license "GPL-3.0-only"
  head "https://github.com/FelixKrueger/Bismark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7206699650e4a46404abbf068a181a449f0797f8d378ef3ad89fe7ed20187141"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1cf73ac9b3c7a76ee6e37e1eb7b6a22f9e0252fb20ee6f27e5147ff4cbd7be87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "49440033fde2c39954670e0ce46c061d0b18e4d3f59093cb4b8b528cd2d64b31"
    sha256 cellar: :any,                 arm64_linux:       "a57ca8f4092bf7c3a7cd06f4694f31b4ec229b2c1ec307642afb7dbfd48b7603"
    sha256 cellar: :any,                 x86_64_linux:      "d6e3cb0a263b3805344b2ca5a6805e3a3a6e1acd02e3d94b04753b9e7ca89fef"
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
