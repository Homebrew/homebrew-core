class Naga < Formula
  desc "Terminal implementation of the Snake game"
  homepage "https://github.com/anayjoshi/naga/"
  url "https://github.com/anayjoshi/naga/archive/naga-v1.0.tar.gz"
  sha256 "7f56b03b34e2756b9688e120831ef4f5932cd89b477ad8b70b5bcc7c32f2f3b3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "060c060175d76dd77c768ec1fd07fe74fc01e404e4f4a6b8be3a75cead596abb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5598664fc7fd64d0f76d0291bbe79c209a65fd8142d6cbf7f7164531d538b9c5"
    sha256 cellar: :any_skip_relocation, monterey:       "6b013d2185f67b684ab4f49db162fdb32bba2dc6914d9855c6f7fbb4bd5603f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "58d4a48fe33e676993449a2cdf332f74b6858681bc5519374d6e7a8842df9434"
    sha256 cellar: :any_skip_relocation, catalina:       "4a397ca0cf60725415818826e47fbf20c4b9cad2bc754128ece0d50279b715fd"
    sha256 cellar: :any_skip_relocation, mojave:         "0deef9e2936b7e5256c4f3e6f22c85389e3b8e53a586018854cbad3b983adc53"
    sha256 cellar: :any_skip_relocation, high_sierra:    "324d31a0ae721075843ff5e326f35efcd1a03d784e92ef8419b954b40a55fae3"
    sha256 cellar: :any_skip_relocation, sierra:         "8baa28b92a0d6970a857c859b11e4a1df878db5270f259bd3ccfe3b5f57f3303"
    sha256 cellar: :any_skip_relocation, el_capitan:     "6ff3dd51d1cdeed9364c36c25d1c2794f973e2927077eaeb251fa0dbfc48a531"
    sha256 cellar: :any_skip_relocation, yosemite:       "fe303605603697993def097e9557a0dcec83d323a0b43d51fb1811108937da6c"
  end

  def install
    bin.mkpath
    system "make", "install", "INSTALL_PATH=#{bin}/naga"
  end

  test do
    assert_predicate bin/"naga", :exist?
  end
end
