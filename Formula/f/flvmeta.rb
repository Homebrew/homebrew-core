class Flvmeta < Formula
  desc "Manipulate Adobe flash video files (FLV)"
  homepage "https://flvmeta.com/"
  url "https://github.com/noirotm/flvmeta/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "59371e286168d6e5c4647d3575c01bcbb30147c4916eb69e10f38cdbc1c5546d"
  license "GPL-2.0-or-later"
  head "https://github.com/noirotm/flvmeta.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7b4a5ecf8a1e932fb391017b6f08d08f37ff1b405a34e9e7b7e4c7e20641a0fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ba117a6573cabe3ccb7b5ae11483fe4fee639ccdb638512d338704604951fc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d758531df2c34ec2ecec08d3a9e9cc9f250b720a38abff2fa5745d2c8ed16aaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b62fd205c68ecd0eb7c13b8d550844f4b7d5d7e48eae9b9f6d8d7ab6f9d84d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1278110538d3806072234a6dc02858b96ed87f8de9110398ba07af5b345f6e4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "17beba4f1b154f4266bdbba7a9115870774b6812a0da0baa762a44c8c65e4b69"
    sha256 cellar: :any_skip_relocation, ventura:        "312b9f4eefa50eeab352a048587d4ce79e0bba6f3591ec1ba31dc3cd9e832dd9"
    sha256 cellar: :any_skip_relocation, monterey:       "cc36bbb5f3c0542bbddc90be35e85bd5d059bb3373dc852b1bdf339dc0bf88e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "e519203e5deb5c2f18f34b12095f4389a5a76d86f914379cb62e397b175e7466"
    sha256 cellar: :any_skip_relocation, catalina:       "bb16f5006d22ffaebba50c0d9c5cc962cf73dfcf1ca51d1e69735908ef9aa8cd"
    sha256 cellar: :any_skip_relocation, mojave:         "176a5edcfbe2da366e27f67590c45870b59ad250cc7f2a51d7a8d0a18f12632b"
    sha256 cellar: :any_skip_relocation, high_sierra:    "2ef376486588157dc4e17914ab8ba62a1689aaf92fe101613f93fd0d05018fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ee08a06c1340135e808d5f305f22d343264c7cd059c250bb0371dab7403a3d9"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"flvmeta", "-V"
  end
end
