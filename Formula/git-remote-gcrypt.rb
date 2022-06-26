class GitRemoteGcrypt < Formula
  desc "GPG-encrypted git remotes"
  homepage "https://spwhitton.name/tech/code/git-remote-gcrypt/"
  url "https://github.com/spwhitton/git-remote-gcrypt/archive/1.4.tar.gz"
  sha256 "12567395bbbec0720d20ec0f89f6f54a7fae4cafedab0fc917164f0deb6b1ef5"
  license "GPL-3.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b7aab9a659d0a49919c77410d4b278a23c22d7fb75071b755c5bd676aa7d6b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a504a2fd03734bd408fcbf085e2ffb190bdcd7752f130a6f1affd850354a85d"
    sha256 cellar: :any_skip_relocation, monterey:       "a949bd95ebb7eb4c2b9875cafefa63befdbcf8d68839ceec127e21c90fc837a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "348795646f446bef6471630348162d3d4ea09e2cee5f71405bdb2da5ab936eac"
    sha256 cellar: :any_skip_relocation, catalina:       "422197237a410ce36132a62aa25d15419a5a88e60affc63ceb2926f7bddacf03"
    sha256 cellar: :any_skip_relocation, mojave:         "a8ac84fcad96a05d2846adf010eba868703b7d3732c25c2da8a103e6780624fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9de2055f06de48f21fc84642b7811e54ad7048527509b6731d5537ff8e2e6fa8"
  end

  depends_on "docutils" => :build

  def install
    ENV["prefix"] = prefix
    system "./install.sh"
  end

  test do
    assert_match("fetch\npush\n", pipe_output("#{bin}/git-remote-gcrypt", "capabilities\n", 0))
  end
end
