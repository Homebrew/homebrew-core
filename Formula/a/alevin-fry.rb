class AlevinFry < Formula
  desc "Efficient and flexible tool for processing single-cell sequencing data"
  homepage "https://github.com/COMBINE-lab/alevin-fry"
  url "https://github.com/COMBINE-lab/alevin-fry/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "1802b9d975ec6f2cee5dfb3fd126a85bcabdcfa68ad5e4ca00e1a3349f2fb2b4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "688995b4dd7c972354b6623a22ee3aa2f89a69f8104b09df26e996381912175b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec1a7c42fa68d6007c8432359747339c70367455ec3cddc567a60ae8eb4f9427"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df17b5864ca585600751988085084337e32cf455d2cc72612a414b92032b9b45"
    sha256 cellar: :any_skip_relocation, sonoma:        "4aa3a0fc4f1f85f1b7fbdcb4f1a6b3d1c2ef11ae24329e117e8ddd06b0183669"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "638c1dc73f8d7441ac0463136c468d57e71a484ed7fde1fd10731e46c1b6b2fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8eec76c739b4bf0f6b436c9420c41116c2842ff28c325ce236745165baff9904"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/alevin-fry --version")

    sam = testpath/"test.sam"
    sam.write <<~EOS
      @SQ\tSN:chr1\tLN:500
      r1\t0\tchr1\t100\t0\t4M\t*\t0\t0\tATGC\t*\tCR:Z:ATGC\tUR:Z:ATGC
    EOS
    system bin/"alevin-fry", "convert", "--bam", "test.sam", "--output", "test.rad"
    assert_path_exists "test.rad"
  end
end
