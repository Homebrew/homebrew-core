class Nkf < Formula
  desc "Network Kanji code conversion Filter (NKF)"
  homepage "https://osdn.net/projects/nkf/"
  # Canonical: https://osdn.net/dl/nkf/nkf-2.1.4.tar.gz
  url "https://dotsrc.dl.osdn.net/osdn/nkf/64158/nkf-2.1.4.tar.gz"
  sha256 "b4175070825deb3e98577186502a8408c05921b0c8ff52e772219f9d2ece89cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d3956870eb3cc800ffa0fbe527ce6012a14b81f98d4af9485fab8e99316560c" => :mojave
    sha256 "1078899ada2ce3d45e4025e0c41f46f5e97856acfabb1c1d07f78fa1bb6f7048" => :high_sierra
    sha256 "f0f532f5f6bba92842ed4da8d9cddbbb949c95933bc6251e6c58575aa5e27949" => :sierra
    sha256 "71a4b7a8a2eef8ae33e8c6f81ebfd8afbcae8237c03720783d2157dcd307b600" => :el_capitan
    sha256 "de741a793e59bc390e3b919f3d3bab245694e7c92c1a821ff60480078f1ae67d" => :yosemite
    sha256 "8b34cb6acebf1a6a446572924c3a585e48ad0007dc394670ee94b9c1fe5d61c2" => :mavericks
  end

  def install
    inreplace "Makefile", "$(prefix)/man", "$(prefix)/share/man"
    system "make", "CC=#{ENV.cc}"
    # Have to specify mkdir -p here since the intermediate directories
    # don't exist in an empty prefix
    system "make", "install", "prefix=#{prefix}", "MKDIR=mkdir -p"
  end

  test do
    system "#{bin}/nkf", "--version"
  end
end
