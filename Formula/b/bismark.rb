class Bismark < Formula
  desc "Bisulfite read mapper and methylation caller"
  homepage "https://github.com/FelixKrueger/Bismark"
  url "https://github.com/FelixKrueger/Bismark/archive/refs/tags/bismark-rust-v3.3.0.tar.gz"
  sha256 "44267c3ec1f88c4d18fc98f36f70b113df154f49f39b2ff2a3fcb3e7b340bebc"
  license "GPL-3.0-only"
  head "https://github.com/FelixKrueger/Bismark.git", branch: "master"

  livecheck do
    url :stable
    regex(/^bismark-rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2ada22dded3b36ae2d4a3af2ea65979cc715caa579311273046e9a47d147d5c8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "29201c3c81ea64986724beef9a5da5acaf41c53a14d2e7093d7dbce7b977559a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "18f2c0206d96ecef5f8b162290f93b8e49df7a8a9a07ad6bd95acd240a15754b"
    sha256 cellar: :any,                 arm64_linux:       "6e07e09deb2856e65c0c1feca00dcc42d7c2a9861229e11278e63b9e92f55f57"
    sha256 cellar: :any,                 x86_64_linux:      "90002616fdd53d4f34ce38862418c695826f0b5dd527754a51168e28c441bfb6"
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
