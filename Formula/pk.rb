class Pk < Formula
  desc "Field extractor command-line utility"
  homepage "https://github.com/johnmorrow/pk"
  url "https://github.com/johnmorrow/pk/releases/download/v1.0.2/pk-1.0.2.tar.gz"
  sha256 "0431fe8fcbdfb3ac8ccfdef3d098d6397556f8905b7dec21bc15942a8fc5f110"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "123a225b6c4a6208cb0b6847bae1cf60ce8934dccbfb1c5c9eb7ed5d055f6c0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "410e868c6d09c373aba677fe256bea9dd1e3a09d867c009e0afba66c6c671c8e"
    sha256 cellar: :any_skip_relocation, monterey:       "21e1d9edcb574d9c010e7bbb08bb4430eeccac5e89f85029a6e247a586117c1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "37e03d0ccea4bda2a3616ba39950d8c685e0a49775ed61abfd4b25649e4d2a25"
    sha256 cellar: :any_skip_relocation, catalina:       "2f9c36e03681f154a24e063e2600d0de8f8afd5f9b114083ef1f34656a7721e8"
    sha256 cellar: :any_skip_relocation, mojave:         "56a1d31b7c52fddecdd11dba3c394b91b38cdf91a9d294c24ae849fa7e27321a"
    sha256 cellar: :any_skip_relocation, high_sierra:    "12cc1f5a82f305734355bc527d6dc936039a86f0b8888d226d0b36a9400d234f"
    sha256 cellar: :any_skip_relocation, sierra:         "790f7e9670dcda15b7472264eea54666e7e34e8adb4343b3699ab87a60c9f3b1"
    sha256 cellar: :any_skip_relocation, el_capitan:     "74c7822b2e3a74bc657d5e8490f184af120eddf9230695fe26dbb075391e10e6"
    sha256 cellar: :any_skip_relocation, yosemite:       "2e86bd1b33521a5856308b58ab35f7384988e9cb6506a4f3d9191ea38361235d"
  end

  depends_on "argp-standalone"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    assert_equal "B C D", pipe_output("#{bin}/pk 2..4", "A B C D E", 0).chomp
  end
end
