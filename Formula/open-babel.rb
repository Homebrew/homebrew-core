class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://openbabel.org"
  url "https://github.com/openbabel/openbabel/archive/openbabel-3-1-1.tar.gz"
  version "3.1.1"
  sha256 "c97023ac6300d26176c97d4ef39957f06e68848d64f1a04b0b284ccff2744f02"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/openbabel/openbabel.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "60cb6bc616f2cda72267dc99601e6349ac1c1d9f27185a58fa60c4ec3dd482f2"
    sha256 arm64_monterey: "f62cb276d94338ddfefe3610db7242b07071522e51b644993d538b27cdd67336"
    sha256 arm64_big_sur:  "d21957b0b507d271ee125ba0ce47bd87eea70c807e78510a06c4066f476eb27d"
    sha256 ventura:        "1a3c9bfdeb58b9fd85c76f2be00878822fabe7e94e7a459e1d4c540607effd41"
    sha256 monterey:       "fe236b2a01b1ac206432b3954c66071bdb0f2b55540c699974a9d6410d0ddfe7"
    sha256 big_sur:        "414dc53a50dd9eb8e5cedfead87ca2c79aae360075ef565c860526a7902167bd"
    sha256 catalina:       "40e04ad79487b0394ea3b34443c9e2d4a6409915e941c54806e4d1fd2b6e3214"
    sha256 x86_64_linux:   "6654aeb57160c573dbe4d069fc36fc8a3ecb46be163cabf0252f17c7a15480a6"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rapidjson" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "eigen"
  depends_on "python@3.10"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DRUN_SWIG=ON",
                    "-DPYTHON_BINDINGS=ON",
                    "-DPYTHON_EXECUTABLE=#{which("python3.10")}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"obabel", "-:'C1=CC=CC=C1Br'", "-omol"
  end
end
