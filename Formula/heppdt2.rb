class Heppdt2 < Formula
  desc "Translation for particle ID's to and from various MC generators and PDG standard"
  homepage "https://cdcvs.fnal.gov/redmine/projects/heppdt/wiki"
  url "https://cern.ch/lcgpackages/tarFiles/sources/HepPDT-2.06.01.tar.gz"
  sha256 "12a1b6ffdd626603fa3b4d70f44f6e95a36f8f3b6d4fd614bac14880467a2c2e"
  license "AFL-3.0"

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
