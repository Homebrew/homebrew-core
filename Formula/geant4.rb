class Geant4 < Formula
  desc "Simulation toolkit for particle transport through matter"
  homepage "https://geant4.web.cern.ch"
  url "https://geant4-data.web.cern.ch/geant4-data/releases/source/geant4.10.06.p02.tar.gz"
  version "10.6.2"
  sha256 "ecdadbf846807af8baa071f38104fb0dcc24847c8475cd8397302e2aefa8f66f"
  revision 1

  bottle do
    cellar :any
    sha256 "ff1b45e5f1c0e51b2716f7b355c2b314677341fc701c534538fda7fc29322f16" => :catalina
    sha256 "c1b90be0a6928f6ae58bc842d61ce792ea6c1d004e51eeab5fe955216ab02b4f" => :mojave
    sha256 "1074777bb8c5f386baec8bf280542b109576a74ad19a9e5c198e1789fc397646" => :high_sierra
  end

  depends_on "cmake" => [:build, :test]
  depends_on "boost-python3"
  depends_on "expat"
  depends_on "python@3.8"
  depends_on "qt"
  depends_on "xerces-c"

  def install
    mkdir "geant-build" do
      args = std_cmake_args + %w[
        ../
        -DGEANT4_USE_GDML=ON
        -DGEANT4_BUILD_MULTITHREADED=ON
        -DGEANT4_USE_PYTHON=ON
        -DGEANT4_INSTALL_DATA=ON
        -DGEANT4_USE_QT=ON
      ]

      system "cmake", *args
      system "make", "install"
    end

    resources.each do |r|
      (share/"Geant4-#{version}/data/#{r.name}#{r.version}").install r
    end
  end

  def caveats
    <<~EOS
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
