class Bioawk < Formula
  desc "AWK modified for biological data"
  homepage "https://github.com/lh3/bioawk"
  url "https://github.com/lh3/bioawk/archive/refs/tags/v1.0.tar.gz"
  sha256 "5cbef3f39b085daba45510ff450afcf943cfdfdd483a546c8a509d3075ff51b5"
  license "HPND"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "091d687b6c2584d1f0a47fbac10ba074ade881df4f0631022ae215ffed68343b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "581ec8168890f6010df9a49953f2d52a3a86020fc350cb7cdb64fae38e23b0c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "781164882120d8b28e1cdac8b8db1f5c9a8bdedea381aedad9b35b6d185f2897"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a80d9d6887393ec604646dd2e79090bda1034f5947488995c383d29b8fbb2f47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a568547e0fb85d1d0678d157c93aee71710f58d3bc4591186365ae28e4502b24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de4d41adcf20cf87de3d2310d98c1dbfbff95eb3432e6d0888be964889f024c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "41b9e0d69738711ac5f1a2269ba11cd6de67303224621e9f52bb5564e76f0098"
    sha256 cellar: :any_skip_relocation, ventura:        "d10e6430821b1876cf8ad863dce1978f7aa4564bc3508e48f7cfa9d8e4d89306"
    sha256 cellar: :any_skip_relocation, monterey:       "844d8041e128ebcf46d1a5dec20dfc22f0a3fc1ff48388310cf810685acd9890"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0e6d3b143b32066da8f41266d1edf2855ab0d780982c8eb09b78194c1e2484e"
    sha256 cellar: :any_skip_relocation, catalina:       "c7377ef6e226404f71d52c04715ea0bb8456e1c90493e93e78101dfb3ed2190e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9c71291338d2d1a4306c9d9124a5475d1ef05357bfb80846d6d573c06f55afaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d611e2578e57304e571f02a58ec46efc83752a97a7d830b40e03a2c83749bb3"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "zlib"

  def install
    # Fix make: *** No rule to make target `ytab.h', needed by `b.o'.
    ENV.deparallelize

    system "make"
    bin.install "bioawk"
    man1.install "awk.1" => "bioawk.1"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCT
      CTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    cmd = "#{bin}/bioawk -cfastx '{print length($seq)}' test.fasta"
    assert_equal "70", shell_output(cmd).chomp
  end
end
