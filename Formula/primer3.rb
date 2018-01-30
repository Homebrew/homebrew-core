class Primer3 < Formula
  desc "Program for designing PCR primers"
  homepage "https://primer3.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/primer3/primer3/2.4.0/primer3-2.4.0.tar.gz"
  sha256 "6d537640c86e2b4656ae77f75b6ad4478fd0ca43985a56cce531fb9fc0431c47"

  bottle do
    cellar :any_skip_relocation
    sha256 "bcc7d166ca32302dca6650cd4097255e7dd2dd3f890a1a864498586b71a44a3e" => :high_sierra
    sha256 "fe08ddd1929b113d59912a7b86bc90eb0dcd47873b2d00263609b685b45c4973" => :sierra
    sha256 "e5c5bd6002dd36aa1fa177dc73bcb2feeae9b7a421a6ecbac4443866827378ae" => :el_capitan
    sha256 "62595ddbfc162732a7d4741b1c331ef51d53fe8ac2008c613447bb4ebb7a2b1c" => :x86_64_linux
  end

  def install
    cd "src" do
      system "make"

      # Lack of make install target reported to upstream
      # https://github.com/primer3-org/primer3/issues/1
      bin.install %w[primer3_core ntdpal ntthal oligotm long_seq_tm_test]
      pkgshare.install "primer3_config"
    end
  end

  test do
    output = shell_output("#{bin}/long_seq_tm_test AAAAGGGCCCCCCCCTTTTTTTTTTT 3 20")
    assert_match "tm = 52.452902", output.lines.last
  end
end
