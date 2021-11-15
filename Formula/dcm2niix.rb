class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/v1.0.20211006.tar.gz"
  sha256 "44b737d0101483de17ac1273f2d2c6a4d572a7b76ea040d69aa34d5e484144b9"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/rordenlab/dcm2niix.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a15bc36f47159f5add0d2de5935e9afb93645cea643f717abb7841487a3dce5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4ccc171c1d9226d2d5f3f4a889b1a2da84060c4ae1b26e61ad7a6acea730188"
    sha256 cellar: :any_skip_relocation, monterey:       "59ee1bb82f8d0e4c588fed7d72ee45c8287aa5cf7673254a674c73d5fc8fbae5"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c66b2cb7523fc1f221317f46162f8c0383bdc9156320d1685058b9a14d93b64"
    sha256 cellar: :any_skip_relocation, catalina:       "21d06e3b2f960deea00b7d4e43e79ab9380715fe291fb7da8be292bde07c0207"
    sha256 cellar: :any_skip_relocation, mojave:         "6f6280dc038a31653b432616c477fae0af86473ac97b04bf0a655a7aa5bd31d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c79afb62032ec43191f973e5ec14d26e3a82b0fa6980cee0c82b6019b2058b4"
  end

  depends_on "cmake" => :build

  resource "sample.dcm" do
    url "https://raw.githubusercontent.com/dangom/sample-dicom/master/MR000000.dcm"
    sha256 "4efd3edd2f5eeec2f655865c7aed9bc552308eb2bc681f5dd311b480f26f3567"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    resource("sample.dcm").stage testpath
    system "#{bin}/dcm2niix", "-f", "%d_%e", "-z", "n", "-b", "y", testpath
    assert_predicate testpath/"localizer_1.nii", :exist?
    assert_predicate testpath/"localizer_1.json", :exist?
  end
end
