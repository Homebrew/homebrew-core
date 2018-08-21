class Libotr < Formula
  desc "Off-The-Record (OTR) messaging library"
  homepage "https://otr.cypherpunks.ca/"
  url "https://otr.cypherpunks.ca/libotr-4.1.1.tar.gz"
  sha256 "8b3b182424251067a952fb4e6c7b95a21e644fbb27fbd5f8af2b2ed87ca419f5"

  bottle do
    cellar :any
    sha256 "90da0033157a7771cf7239d038f36e0d613616f1918a168fa763f3e2eafc0106" => :mojave
    sha256 "0b340441feba4b325c3ff5c26a9e79b16294461f6f681ae42a2a5d45966e7391" => :high_sierra
    sha256 "9f0b214278e4cdf81a1a0c083f1aa45ba64430b449121c4d0596357952dcc93d" => :sierra
    sha256 "43d7a166cd12b611e7bf15dfa3865d18e573a81a218e2aeb0061d51203ecde39" => :el_capitan
    sha256 "b3f215fd3952f7a97af36500365c3c017f23de107162f4c76b0e48355bd2a358" => :yosemite
    sha256 "12338de29acd18bb5d7a90552e33b1a353ae7de3f10ab0316dfd6bda379d919b" => :mavericks
  end

  depends_on "libgcrypt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
