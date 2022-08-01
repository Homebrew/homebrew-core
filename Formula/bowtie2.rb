class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/bowtie2/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.4.5.tar.gz"
  sha256 "db101391b54a5e0eeed7469b05aee55ee6299558b38607f592f6b35a7d41dcb6"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "495bc223b670a7e029315ce992dcc0811dc3f63e714c656b6cb84c2f789aa439"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf63043431156ed49e8034700900c508f32e02cd1830a8f815ed83735544dd5b"
    sha256 cellar: :any_skip_relocation, monterey:       "bd2176ef8b56c77260602d72566a6ad85240f8c7def21317b31913995e0789d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f1d5777e5ec4d9aa9ffe38f18278f1a0aba3679d19d5a57a30343074ba25866"
    sha256 cellar: :any_skip_relocation, catalina:       "03cd26ce1b340a37c66c1097c426a9e423d6f57bf809558bad577fb827e271d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46f6e5aa64fd0f9564d15f21aa0ac84d9960fb79424539599c284d0f7724e096"
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
