class Geant4 < Formula
  desc "Simulation toolkit for particle transport through matter"
  homepage "https://geant4.web.cern.ch"
  url "https://geant4-data.web.cern.ch/geant4-data/releases/source/geant4.10.04.p02.tar.gz"
  version "10.4.2"
  sha256 "2cac09e799f2eb609a7f1e4082d3d9d3d4d9e1930a8c4f9ecdad72aad35cdf10"

  bottle do
    cellar :any
    sha256 "800c78ecd5b63b1337304914c29ad17163f1b8c9ae51f729db470e64a55d9338" => :mojave
    sha256 "da797eb6fe9d82232e1f0ab6700918f65b8f88605a2c13341853cfa99fae6cc8" => :high_sierra
    sha256 "4cf26fde6a885de65a48bfca295cc2cfc6d3513321bedd89fb943c8729f3e6e2" => :sierra
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt"
  depends_on "xerces-c"

  resource "G4NDL" do
    url "https://cern.ch/geant4-data/datasets/G4NDL.4.5.tar.gz"
    sha256 "cba928a520a788f2bc8229c7ef57f83d0934bb0c6a18c31ef05ef4865edcdf8e"
  end

  resource "G4EMLOW" do
    url "https://cern.ch/geant4-data/datasets/G4EMLOW.7.3.tar.gz"
    sha256 "583aa7f34f67b09db7d566f904c54b21e95a9ac05b60e2bfb794efb569dba14e"
  end

  resource "PhotonEvaporation" do
    url "https://cern.ch/geant4-data/datasets/G4PhotonEvaporation.5.2.tar.gz"
    sha256 "83607f8d36827b2a7fca19c9c336caffbebf61a359d0ef7cee44a8bcf3fc2d1f"
  end

  resource "RadioactiveDecay" do
    url "https://cern.ch/geant4-data/datasets/G4RadioactiveDecay.5.2.tar.gz"
    sha256 "99c038d89d70281316be15c3c98a66c5d0ca01ef575127b6a094063003e2af5d"
  end

  resource "G4SAIDDATA" do
    url "https://cern.ch/geant4-data/datasets/G4SAIDDATA.1.1.tar.gz"
    sha256 "a38cd9a83db62311922850fe609ecd250d36adf264a88e88c82ba82b7da0ed7f"
  end

  resource "G4NEUTRONXS" do
    url "https://cern.ch/geant4-data/datasets/G4NEUTRONXS.1.4.tar.gz"
    sha256 "57b38868d7eb060ddd65b26283402d4f161db76ed2169437c266105cca73a8fd"
  end

  resource "G4ABLA" do
    url "https://cern.ch/geant4-data/datasets/G4ABLA.3.1.tar.gz"
    sha256 "7698b052b58bf1b9886beacdbd6af607adc1e099fc730ab6b21cf7f090c027ed"
  end

  resource "G4PII" do
    url "https://cern.ch/geant4-data/datasets/G4PII.1.3.tar.gz"
    sha256 "6225ad902675f4381c98c6ba25fc5a06ce87549aa979634d3d03491d6616e926"
  end

  resource "G4ENSDFSTATE" do
    url "https://cern.ch/geant4-data/datasets/G4ENSDFSTATE.2.2.tar.gz"
    sha256 "dd7e27ef62070734a4a709601f5b3bada6641b111eb7069344e4f99a01d6e0a6"
  end

  def install
    mkdir "geant-build" do
      args = std_cmake_args + %w[
        ../
        -DGEANT4_USE_GDML=ON
        -DGEANT4_BUILD_MULTITHREADED=ON
        -DGEANT4_USE_QT=ON
      ]

      system "cmake", *args
      system "make", "install"
    end

    resources.each do |r|
      (share/"Geant4-#{version}/data/#{r.name}#{r.version}").install r
    end
  end

  def caveats; <<~EOS
    Because Geant4 expects a set of environment variables for
    datafiles, you should source:
      . #{HOMEBREW_PREFIX}/bin/geant4.sh (or .csh)
    before running an application built with Geant4.
  EOS
  end

  test do
    system "cmake", share/"Geant4-#{version}/examples/basic/B1"
    system "make"
    (testpath/"test.sh").write <<~EOS
      . #{bin}/geant4.sh
      ./exampleB1 run2.mac
    EOS
    assert_match "Number of events processed : 1000",
                 shell_output("/bin/bash test.sh")
  end
end
