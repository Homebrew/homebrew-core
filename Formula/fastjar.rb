class Fastjar < Formula
  desc "Implementation of Sun's jar tool"
  homepage "https://savannah.nongnu.org/projects/fastjar"
  url "https://download.savannah.nongnu.org/releases/fastjar/fastjar-0.98.tar.gz"
  sha256 "f156abc5de8658f22ee8f08d7a72c88f9409ebd8c7933e9466b0842afeb2f145"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd0faa9a7294fe6dcee4e48d6fa987f46b3c713390594251244a280ee20a71b5" => :mojave
    sha256 "0884c36bf9d1ea07880caa682fbf64076ae86eb732fb151a5ee42e02a76ff272" => :high_sierra
    sha256 "5d03ecf7d89b4c9cd3ca25735692b77f55ae7df83bdb4073e013f5361256c689" => :sierra
    sha256 "996937a030b443cee74e1de1945e3199022fc27514cf9925c332ed5d5804c80a" => :el_capitan
    sha256 "07dd91fef374251b87b1a2987089234a3da225b79313afa4d8a7f502d1a51aae" => :yosemite
    sha256 "4e1d46c61723a1babbba0841b9dbde5c33388e107202f6ca292adc23ab7149a3" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fastjar", "-V"
    system "#{bin}/grepjar", "-V"
  end
end
