class Bismark < Formula
  desc "Bisulfite read mapper and methylation caller"
  homepage "https://github.com/FelixKrueger/Bismark"
  url "https://github.com/FelixKrueger/Bismark/archive/refs/tags/bismark-rust-v3.5.0.tar.gz"
  sha256 "d81688b1457be6e1238cf2e353face61d5c2cb91ebcf1a108934517a3074e440"
  license "GPL-3.0-only"
  head "https://github.com/FelixKrueger/Bismark.git", branch: "master"

  livecheck do
    url :stable
    regex(/^bismark-rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "b9fe5ee157769e13fc6c7292128ccca339303fa8e0e78d68f85deabbd12f426d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ad132d3db498156295dbb1fe6f54a44f38644ae0d879c687d2bb422b05458f45"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "039c171563d58638b7663b13d93a4862f807ecea0f9fdc05543da1f7635671c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "37650678f4e60ca346fa66f69238ffc8223820b9b06dc4cc770c0fce3153941e"
    sha256 cellar: :any,                 arm64_linux:       "16f83cc4e822c9b578f4288fa12bb8eb7fb5e3e7ed3e2b8cd59922bd0100e873"
    sha256 cellar: :any,                 x86_64_linux:      "1be71673ad53f0430de7967b4111a4120ec6b845d14e6d62d17d76aa914232ca"
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
