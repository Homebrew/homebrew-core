class Heppdt2 < Formula
  desc "Translation for particle ID's to and from various MC generators and PDG standard"
  homepage "https://cdcvs.fnal.gov/redmine/projects/heppdt/wiki"
  url "https://cern.ch/lcgpackages/tarFiles/sources/HepPDT-2.06.01.tar.gz"
  sha256 "12a1b6ffdd626603fa3b4d70f44f6e95a36f8f3b6d4fd614bac14880467a2c2e"
  license "AFL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2b0f2ffc2837fee3dbf5aea96b1a7329c574373578548986c95cdf50b7f0171a"
    sha256 cellar: :any_skip_relocation, big_sur:       "ad2b96b10116b7be43a7fb93f0dd76346c904b9fc281983cbb954dd21674499e"
    sha256 cellar: :any_skip_relocation, catalina:      "5cefdebab8dadafb0c96b121eab2dc0abf0cf6b2f7ff5acdd4d67353c05c275b"
    sha256 cellar: :any_skip_relocation, mojave:        "2c0ccad4374004249fc7431acaa358d0b04d096526e6447ec0c10cdc3b4759af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a9fd6f6dc87942bb05ce6105a4038ce7c824c25636a0b110b33bdb9b25cb15a"
  end

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
