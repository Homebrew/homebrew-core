class GoogleSparsehash < Formula
  desc "Extremely memory-efficient hash_map implementation"
  homepage "https://github.com/sparsehash/sparsehash"
  url "https://github.com/sparsehash/sparsehash/archive/sparsehash-2.0.4.tar.gz"
  sha256 "8cd1a95827dfd8270927894eb77f62b4087735cbede953884647f16c521c7e58"
  license "BSD-3-Clause"
  head "https://github.com/sparsehash/sparsehash.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cee10f1f45f9aa17c0a63573fb8065dea21f9f79c075fafeee699649d50f28d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f24d74610bacd7a53f950e58f03b6d674d43a15495973d09c006e44e6721fde8"
    sha256 cellar: :any_skip_relocation, monterey:       "748df13f800d3d41d0c5c27f63cc349564b26029ba23659157f638e6753bfba1"
    sha256 cellar: :any_skip_relocation, big_sur:        "530dad7aa78d4420bbcbe5dbd6ab1a634acbc29a22576f19ec31af556ed4332c"
    sha256 cellar: :any_skip_relocation, catalina:       "11390608ee72647c06a9735f89535604e6ed2b2531431f9eb81bdf423ab07620"
    sha256 cellar: :any_skip_relocation, mojave:         "11390608ee72647c06a9735f89535604e6ed2b2531431f9eb81bdf423ab07620"
    sha256 cellar: :any_skip_relocation, high_sierra:    "11390608ee72647c06a9735f89535604e6ed2b2531431f9eb81bdf423ab07620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc2afe1af778fc2217f2bc84ab4e38d0cdd96420ac08e4f9e909fa07e83efbdb"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end
end
