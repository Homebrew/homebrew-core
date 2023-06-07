class Arss < Formula
  desc "Analyze a sound file into a spectrogram"
  homepage "https://arss.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arss/arss/0.2.3/arss-0.2.3-src.tar.gz"
  sha256 "e2faca8b8a3902226353c4053cd9ab71595eec6ead657b5b44c14b4bef52b2b2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8daf9486dc32c8698fa1fb731ceb12b04d00019043a803803a71e7472a0781ee"
    sha256 cellar: :any,                 arm64_monterey: "89e8bfca3e620702bbf44ad9f75dcf18c48ef90b5ea97709a657be4cf15e6d25"
    sha256 cellar: :any,                 arm64_big_sur:  "0f31b0ca051c5caa089350b30ffd07bed2c24ff2c64dcec6776e19d594b36ad7"
    sha256 cellar: :any,                 ventura:        "1be5f2c7ce8ee18a767065c0ed7b3783de17a36dae8eaf73f838537ece38fb71"
    sha256 cellar: :any,                 monterey:       "22747b60848d59c6989707efb0373305af7376de07a4e8958426ddff11ff6bc5"
    sha256 cellar: :any,                 big_sur:        "153a648ed0bdec6e1f0abbdbefff2815b793bf79c4967c803cf55a512228dcfa"
    sha256 cellar: :any,                 catalina:       "d84220ffc41768520239228b13a8466493682fa30a670163041caa0b06f449a2"
    sha256 cellar: :any,                 mojave:         "891cda5121a3ea035215f0113d5291fa9afd468e68cc3dc9238b203985fcfe96"
    sha256 cellar: :any,                 high_sierra:    "b848efa3abde7c5fffd18289c1ab51a842cd93e0e97d6af32329acf869909d38"
    sha256 cellar: :any,                 sierra:         "2311c31ae2e80905dfc41c8adb9639314664103352540b198f24c54e0c102550"
    sha256 cellar: :any,                 el_capitan:     "5da45934b19d0cab02c809932fb8c5da3fd76d2f781bc9e2e7a98fa1825989eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5c0a1ade41f7ff063620d37b071556cd71382e9728f160c24393809f89c0f80"
  end

  depends_on "cmake" => :build
  depends_on "fftw"

  def install
    cd "src" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/arss", "--version"
  end
end
