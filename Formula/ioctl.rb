class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.7.1.tar.gz"
  sha256 "7b6ca0f403b092102c42ca56daa9e1f3e64d945de0a4c298e3f5cc092f7c3fa6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c67e61d126c19ba1238b128bccf5245cf5082293431f7204dee1da5cd063415"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0f73de0acb7bf6ff96fdd7e42ee32b1423f5101be5922298f664e1c0444eaef"
    sha256 cellar: :any_skip_relocation, monterey:       "5a7b0dbcdfe5e306c1d4f8d093e3016fe83c26281a16df1decef3bd0ba20925a"
    sha256 cellar: :any_skip_relocation, big_sur:        "45887786f4b2f69955ff35aefd5f47fa2f57827c1ceacff25c268d49a08f2ac4"
    sha256 cellar: :any_skip_relocation, catalina:       "a975d4c4af6a51f50523982404aa49631921c196cacd9fe339e1f8edc829e6b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ecdd8e8637b122ab12f24792f4c6001fdd387c87765b3697d462473a8b0e07e"
  end

  depends_on "go" => :build

  def install
    system "make", "ioctl"
    bin.install "bin/ioctl"
  end

  test do
    output = shell_output "#{bin}/ioctl config set endpoint api.iotex.one:443"
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end
