class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.net/bowtie2/index.shtml"
  url "https://github.com/BenLangmead/bowtie2/archive/refs/tags/v2.5.4.tar.gz"
  sha256 "841a6a60111b690c11d1e123cb5c11560b4cd1502b5cee7e394fd50f83e74e13"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "dcc146d51b08ed4a73d4938caf374776304df1e6ab8dda1cd964ece3c570f8e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3f8eca3ff38d6b573a73c160da0b80a8d20d29a5d11c07ad0c3de51f30986636"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "539b0d025ccf750ab75234c6b1ce0cbe2db9cd1cb3aac64e645ed2703d3f93d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f0ea46f0fb6351e20c753a488ab35b8af656b025dcd8529cf489391afa53a5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27fbcb3ea2f44568313fc80d900018727c376ce862a2e107540d73a5e118d7f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "0851d07d8a4a57897ea4b2262d88073d35060638e297fd8ce3ca9b26eb510ceb"
    sha256 cellar: :any_skip_relocation, ventura:        "65d7c4f3afd8c3437222126d750ea55f6bb4214907072f97ff1bae4c26788465"
    sha256 cellar: :any_skip_relocation, monterey:       "76a63cb64ac6060cdeb35bf4e64e2dca18525ec103a8956e38fe6a9487aba434"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3e4616762d3c198fa8b078654a6b98dd45d128a25731004a84666baae6ae92cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "574eeb3b13bb869e57844bea2fac0eaf789b708096e7b94d5f14b604655b78a9"
  end

  uses_from_macos "perl"
  uses_from_macos "python"
  uses_from_macos "zlib"

  on_arm do
    depends_on "simde" => :build
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "example", "scripts"
  end

  test do
    system bin/"bowtie2-build",
           "#{pkgshare}/example/reference/lambda_virus.fa", "lambda_virus"
    assert_path_exists testpath/"lambda_virus.1.bt2", "Failed to create viral alignment lambda_virus.1.bt2"
  end
end
