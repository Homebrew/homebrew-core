class Bismark < Formula
  desc "Bisulfite read mapper and methylation caller"
  homepage "https://github.com/FelixKrueger/Bismark"
  url "https://github.com/FelixKrueger/Bismark/archive/refs/tags/bismark-rust-v3.1.0.tar.gz"
  sha256 "638d7b068031b23fca9c3b3ca5a6b0db675a4da9d48975420fa642b584b5e411"
  license "GPL-3.0-only"
  head "https://github.com/FelixKrueger/Bismark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "293fda0368b8b74019e9999819cd01eaa624b4acec7394e590cb4ba8af0ac1d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9ef6da69cbacb0b255dbae4b26a2a360c47862da106b45ec1a80fe3322686fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef1a51e4e571ea64730c9c5d57cafe3c245d49ed42f8bdee14a1338e7ac5234a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2831e88732c534227cde21ca650ba6b6522948b30dd522d52c6786e3ef0c1e1e"
    sha256 cellar: :any,                 arm64_linux:   "ebd1d990d2b691b3f5fa28fa47432d93cc93bb6f845731a168e9ddf564f26e58"
    sha256 cellar: :any,                 x86_64_linux:  "d235111cdfe3f691965eabe31f6cee0a0442fa1d6145da3be3f6aa7ad02c0824"
  end

  depends_on "rust" => :build
  depends_on "bowtie2"
  depends_on "minimap2"

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
