class Heppdt2 < Formula
  desc "Translation for particle ID's to and from various MC generators and PDG standard"
  homepage "https://cdcvs.fnal.gov/redmine/projects/heppdt/wiki"
  url "https://cern.ch/lcgpackages/tarFiles/sources/HepPDT-2.06.01.tar.gz"
  sha256 "12a1b6ffdd626603fa3b4d70f44f6e95a36f8f3b6d4fd614bac14880467a2c2e"
  license "AFL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a88323276e43919598c99db83cb8ad62864a6c3fa87045791ae7b65f5c8c1aeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2114a3a999db405565067ff1590fec7434c1481f6ba57416d2a722baf19991e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5527abc757007282f1ff1d2eefb61d6febfb6343fc411d17ff0f79e1ee39c69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1edccaf839fb239d8d8b583b03537bb8789f939afa610df5b806f2ff15243d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b0f2ffc2837fee3dbf5aea96b1a7329c574373578548986c95cdf50b7f0171a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e903e846adbe99c02072c6e20bd9ab59dfcd673bc24ed43d84f80eadbba03ee9"
    sha256 cellar: :any_skip_relocation, ventura:        "f248471e73e458133f30b910b846157b4fb7dfc1bc403123503ec01c1a9a55fe"
    sha256 cellar: :any_skip_relocation, monterey:       "d41f92b1fe64fe52327e3a3f80d04acdc449a9c9d40d9a75dba40700382f51a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad2b96b10116b7be43a7fb93f0dd76346c904b9fc281983cbb954dd21674499e"
    sha256 cellar: :any_skip_relocation, catalina:       "5cefdebab8dadafb0c96b121eab2dc0abf0cf6b2f7ff5acdd4d67353c05c275b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a9fd6f6dc87942bb05ce6105a4038ce7c824c25636a0b110b33bdb9b25cb15a"
  end

  disable! date: "2025-01-05", because: :unmaintained

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system ENV.cxx, "#{prefix}/examples/HepPDT/examMyPDT.cc", "-I#{include}", "-L#{lib}", "-lHepPDT", "-lHepPID"
    system "./a.out"
  end
end
