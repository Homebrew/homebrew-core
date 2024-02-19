class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.net/bowtie2/index.shtml"
  url "https://github.com/BenLangmead/bowtie2/archive/refs/tags/v2.5.3.tar.gz"
  sha256 "4ac3ece3db011322caab14678b9d80cfc7f75208cdaf0c58b24a6ea0f1a0a60e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b39ab941f6d8f54b48cc3661208032cd89d7e1ef968df1614e6469e747b4af57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e30556ae9d469aa988bd6f262196c47ebf9b6956ba3fba289c6fec7aec63e650"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40b9cdc4513c243e3f300087538db5df08d90b7649a2f660ed288f15d66d22b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f6dcb46393d347ea5d7ae2f6548407383bfd226b58d370a6759e232209928dd"
    sha256 cellar: :any_skip_relocation, ventura:        "a05b915d75b2ba43c24828b93e560f8c02fd9427fe59b2a49402100a7de2839a"
    sha256 cellar: :any_skip_relocation, monterey:       "208bda3b6f36f488d81e01b5994ef08a04df3724eb79dd39e041b51fefc0c05c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "573d49ae9737ccb848f128f5de530d03995dabdc511230ddfea5723692a2a6cd"
  end

  uses_from_macos "perl"
  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_arm do
    depends_on "simde" => :build
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "example", "scripts"
  end

  test do
    system "#{bin}/bowtie2-build",
           "#{pkgshare}/example/reference/lambda_virus.fa", "lambda_virus"
    assert_predicate testpath/"lambda_virus.1.bt2", :exist?,
                     "Failed to create viral alignment lambda_virus.1.bt2"
  end
end
