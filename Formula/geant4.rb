class Geant4 < Formula
  desc "Simulation toolkit for particle transport through matter"
  homepage "https://geant4.web.cern.ch"
  url "https://geant4-data.web.cern.ch/geant4-data/releases/source/geant4.10.05.p01.tar.gz"
  version "10.5.1"
  sha256 "f4a292220500fad17e0167ce3153e96e3410ecbe96284e572dc707f63523bdff"

  bottle do
    cellar :any
    sha256 "ff910f3a7b5d6b3c371534183d300b12ba3041a52bb3ae65e9724e726f73986b" => :mojave
    sha256 "61afcd42a08f3faad4ea26a0ebd24d6e71d83747bd3f189ccf614425736910dd" => :high_sierra
    sha256 "39dfed47c21318131cdb76fa383c527073199846b54985e2f2e65c46b05203e4" => :sierra
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt"
  depends_on "xerces-c"

  resource "G4NDL" do
    url "https://cern.ch/geant4-data/datasets/G4NDL.4.5.tar.gz"
    sha256 "cba928a520a788f2bc8229c7ef57f83d0934bb0c6a18c31ef05ef4865edcdf8e"
  end

  resource "G4EMLOW" do
    url "https://cern.ch/geant4-data/datasets/G4EMLOW.7.7.tar.gz"
    sha256 "16dec6adda6477a97424d749688d73e9bd7d0b84d0137a67cf341f1960984663"
  end

  resource "PhotonEvaporation" do
    url "https://cern.ch/geant4-data/datasets/G4PhotonEvaporation.5.3.tar.gz"
    sha256 "d47ababc8cbe548065ef644e9bd88266869e75e2f9e577ebc36bc55bf7a92ec8"
  end

  resource "RadioactiveDecay" do
    url "https://cern.ch/geant4-data/datasets/G4RadioactiveDecay.5.3.tar.gz"
    sha256 "5c8992ac57ae56e66b064d3f5cdfe7c2fee76567520ad34a625bfb187119f8c1"
  end

  resource "G4SAIDDATA" do
    url "https://cern.ch/geant4-data/datasets/G4SAIDDATA.2.0.tar.gz"
    sha256 "1d26a8e79baa71e44d5759b9f55a67e8b7ede31751316a9e9037d80090c72e91"
  end

  resource "G4PARTICLEXS" do
    url "https://cern.ch/geant4-data/datasets/G4PARTICLEXS.1.1.tar.gz"
    sha256 "100a11c9ed961152acfadcc9b583a9f649dda4e48ab314fcd4f333412ade9d62"
  end

  resource "G4ABLA" do
    url "https://cern.ch/geant4-data/datasets/G4ABLA.3.1.tar.gz"
    sha256 "7698b052b58bf1b9886beacdbd6af607adc1e099fc730ab6b21cf7f090c027ed"
  end

  resource "G4INCL" do
    url "https://cern.ch/geant4-data/datasets/G4INCL.1.0.tar.gz"
    sha256 "716161821ae9f3d0565fbf3c2cf34f4e02e3e519eb419a82236eef22c2c4367d"
  end

  resource "G4PII" do
    url "https://cern.ch/geant4-data/datasets/G4PII.1.3.tar.gz"
    sha256 "6225ad902675f4381c98c6ba25fc5a06ce87549aa979634d3d03491d6616e926"
  end

  resource "G4ENSDFSTATE" do
    url "https://cern.ch/geant4-data/datasets/G4ENSDFSTATE.2.2.tar.gz"
    sha256 "dd7e27ef62070734a4a709601f5b3bada6641b111eb7069344e4f99a01d6e0a6"
  end

  resource "RealSurface" do
    url "https://cern.ch/geant4-data/datasets/G4RealSurface.2.1.1.tar.gz"
    sha256 "90481ff97a7c3fa792b7a2a21c9ed80a40e6be386e581a39950c844b2dd06f50"
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
