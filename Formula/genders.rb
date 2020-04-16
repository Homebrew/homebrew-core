class Genders < Formula
  desc "Static cluster configuration database for cluster management"
  homepage "https://github.com/chaos/genders"
  url "https://github.com/chaos/genders/archive/genders-1-27-3.tar.gz"
  version "1.27.3"
  sha256 "c176045a7dd125313d44abcb7968ded61826028fe906028a2967442426229894"

  bottle do
    cellar :any
    sha256 "d87fb37a4218b226478fa012c55f761bc2cb1d27bad2a1a058520fd697935ade" => :catalina
    sha256 "ca1e1452a598fd313b76788262c762c75eadf975cc2a07fe49937823350acef9" => :mojave
    sha256 "67d6136a20f82c2e249d9b98ef2394bc98ae1ca40daec766255a4d1c67cbd8d8" => :high_sierra
    sha256 "af7991bf0459a88559c4a09a3be4fa96b26d17dea3750bc964f244c2754ffd0d" => :sierra
    sha256 "4d5c7ced8593d2571b06d076a16ccce0bfcc99a1ea3f314b3f5f0d09d18c6076" => :el_capitan
    sha256 "f4e7550bac6a7d427ada6d5af16b5e5bbae52786fbad1f673af1e296bace5343" => :yosemite
    sha256 "c455a536ad6b100887fbc6badf0e054157cf961ea02802f67a694c5e8dd30b96" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--with-java-extensions=no"
    system "make", "install"
  end

  test do
    (testpath/"cluster").write <<~EOS
      # slc cluster genders file
      slci,slcj,slc[0-15]  eth2=e%n,cluster=slc,all
      slci                 passwdhost
      slci,slcj            management
      slc[1-15]            compute
    EOS
    assert_match "0 parse errors discovered", shell_output("#{bin}/nodeattr -f cluster -k 2>&1")
  end
end
