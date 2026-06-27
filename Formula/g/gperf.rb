class Gperf < Formula
  desc "Perfect hash function generator"
  homepage "https://www.gnu.org/software/gperf/"
  url "https://ftpmirror.gnu.org/gnu/gperf/gperf-3.3.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gperf/gperf-3.3.tar.gz"
  sha256 "fd87e0aba7e43ae054837afd6cd4db03a3f2693deb3619085e6ed9d8d9604ad8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8431153ec71d07fd4f1ca9609c1c11e9f6cc487000cb2f5e4cbec971c0814536"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b88bc4005a80b6115e8d15bca5f74af0e7e7eab6355ca0499fe41194c68053e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd4c9ce8fb554dc69f5533ac020556993a6a6cbd302b5029ca1b5d106a491eaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c23eeb8f50029a8cab08a602f82786eed3409fbda31901f8c6e03acab6bc4b02"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e9bff915d62ffa5029f929aeefa07383aafe3f0f92921224f39447b3af71787"
    sha256 cellar: :any_skip_relocation, ventura:       "f88499737add86611067de8160cb81ebda7c03269df980af4b91cb1f0fbc07b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f53bc80b9dc52d53c19a2bcd50a32114860348be40cd3bf3252c8270f0bbf24f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b89551d7e9b6af83d8ff495b7ec376cbf0b73c37b39ee90a4164a115496cd11e"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "TOTAL_KEYWORDS 3",
      pipe_output(bin/"gperf", "homebrew\nfoobar\ntest\n")
  end
end
