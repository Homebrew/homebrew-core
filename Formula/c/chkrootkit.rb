class Chkrootkit < Formula
  desc "Rootkit detector"
  homepage "https://www.chkrootkit.org/"
  url "ftp://ftp.chkrootkit.org/pub/seg/pac/chkrootkit-0.58b.tar.gz"
  mirror "https://fossies.org/linux/misc/chkrootkit-0.58b.tar.gz"
  sha256 "75ed2ace81f0fa3e9c3fb64dab0e8857ed59247ea755f5898416feb2c66807b9"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?download[^>]*>chkrootkit v?(\d+(?:\.\d+)+[a-z]?)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d6c88090d0b0df29d22316c63db70ba590217ff88ca82e0fe9986a282503bb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b2e02512815e0752d64b43908190240ac58c5f3895200c876b5328f78ce9345"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81fe5bf8ee342b99e6048b3908f49c0c6cb21edd0374cebf439808986106c7e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5533e32cc63a4c5de2e644afa929f5d55dc87999f6dfdab84bc5cc943a85c527"
    sha256 cellar: :any_skip_relocation, sonoma:        "27f7982730e34a76130cbc1d775845f17480053cd8fb46a76bf8317d36f57771"
    sha256 cellar: :any_skip_relocation, ventura:       "3845af7aac3b4114fbf0eac4fb38c79afc0fd2a6a3eb8063f2598cc697e79221"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1939dc0c9796b737d27bfdc51196fbbb0c8239e184472387bc17aa5f1fe10af5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93aec292d7e8a289ffccd9cd35591ee1ea2dd6ad8e11b3b9320171afc9710e6b"
  end

  def install
    ENV.deparallelize

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}",
                   "STATIC=", "sense", "all"

    bin.install Dir[buildpath/"*"].select { |f| File.executable? f }
    doc.install %w[README README.chklastlog README.chkwtmp]
  end

  test do
    assert_equal "chkrootkit version #{version}",
                 shell_output("#{bin}/chkrootkit -V 2>&1", 1).strip
  end
end
