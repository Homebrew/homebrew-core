class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/v1.0.20230411.tar.gz"
  sha256 "990368e627a7d972a607ef965161e4ab0ddc5b0be35d659c1ce387c8ddae8301"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/rordenlab/dcm2niix.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9168cedeb1403132e6e32ea44c38ee566b458766eb2a9b2d2e1795ebe62128da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "646b444246653c09158281f1eadc660dabaed791f61167c4975c9a964aa41986"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cbf4e3e61a81ff0ac4daed870f71653c9a40b92ec85d640db9b6ff293787152"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e250cdb698d8db5e365a0f6a752904f80140e02e8d59daae195a604a0589917"
    sha256 cellar: :any_skip_relocation, sonoma:         "efd82e8bf88135f9fec9dad66fca05b4ea9229dad17b284ea4b1bb9f4c4d2ea5"
    sha256 cellar: :any_skip_relocation, ventura:        "bac453b5a1f5fce0fa171f60740b1d67518f3ad16f3b957ee828f55700ca450a"
    sha256 cellar: :any_skip_relocation, monterey:       "5a06eac1f532dc970fd53c7032179f24bf279ad9aad3430cceee3859013bc5b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a6e9abfd7048110de17f69b436c3262cde76888aa4041b535fbf02fc056da56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c262a91f2cb0ce4dfa0716e36ae9963d4ed92652f8cae06f91a0bc7eae5d6c0"
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
