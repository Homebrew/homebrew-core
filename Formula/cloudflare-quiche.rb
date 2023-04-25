class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.17.1",
      revision: "adca4bc48b2061e92cbc6faa4ec972da7e356b5b"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4cb85409b0142142edab87257fee47c57bd7f47780d2024071544eb8148fd9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc7ff9a9b387b2e187a54fa9017fed00ed6df27bf53d0c20705fd24558e7937e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afcd7ad4568158b094b3a00070ff6d82bdab732502246f2fcf0f6e66883d7f01"
    sha256 cellar: :any_skip_relocation, ventura:        "747d8208f5d904546a7aaf67327c5199238bd4af6f02e27fcfc4020d3139b24e"
    sha256 cellar: :any_skip_relocation, monterey:       "a735f8af71c3758b9580bd50040ba50964e94f7c35979c457f977cef0e7cb249"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b50ff95c531789bb7fb618179bf390c99a127bfe7c420c3e75852d20b481e1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fdebae2c07fbd90106786af6ec91f760d12a0a5bc796d993958744c823249c5"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps")
  end

  test do
    assert_match "it does support HTTP/3!", shell_output("#{bin}/quiche-client https://http3.is/")
  end
end
