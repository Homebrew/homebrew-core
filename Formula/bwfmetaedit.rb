class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/21.07/BWFMetaEdit_CLI_21.07_GNU_FromSource.tar.bz2"
  sha256 "7b55d9c6df989a3cbff2bb2c9a18b0b0f3a80fa716539a160d612194906d94f2"
  license "0BSD"

  livecheck do
    url "https://mediaarea.net/BWFMetaEdit/Download/Source"
    regex(/href=.*?bwfmetaedit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55db76b2cdd9dea54d82e644f9de1c5f5ca53cc552602115ab45704f30aef612"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "990843dbcb7a326453234dcdedb6af987be548adecc3edca6dba0086c16d689d"
    sha256 cellar: :any_skip_relocation, monterey:       "79b70c2fe4f006d8997f05cc548148682050712366f6c26cdb90bba21e40bb42"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc4935bced4e3226e4e0fb61dbf8821ee25fb36126c494e4e93f084728032be3"
    sha256 cellar: :any_skip_relocation, catalina:       "c5168b4682ae67f6ad9618761706b4589d6ad45fb55df851602dab205a8a7299"
    sha256 cellar: :any_skip_relocation, mojave:         "836a3ad812aaeb0128ac0e3fe75eee3d33c6f2c2a98f92138af02cf74173c665"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08a47ae2efd7c64a5a5eb5cc9ecdd2046d0b0f20169257af529dd9ae0e3891d3"
  end

  def install
    cd "Project/GNU/CLI" do
      system "./configure",  "--disable-debug", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/bwfmetaedit --out-tech", test_fixtures("test.wav"))
  end
end
