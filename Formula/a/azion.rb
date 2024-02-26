class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/1.13.1.tar.gz"
  sha256 "e32dd8466c7d40386140af304faac62511e570abca26bb80a477abee96e8fcff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "780de48b1aeca8e35c2d1e27050e10111a209ad81b5b16d611483de4046c0f52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23423096713831e8526944b7a9682e5629624d2e81f6ebc479be6301c8055c9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e34a43e0ca11be1ed81f7afd675407f6b4169ee121e61327a8edbb7696db7b83"
    sha256 cellar: :any_skip_relocation, sonoma:         "d18a5f9920590b2505c5711c1fd9c88ef713d419fd6c0baa9dd769a86b3ef6e3"
    sha256 cellar: :any_skip_relocation, ventura:        "e3509e7ebd14a1791abb7e97f61d29725865502d2007bea47bf0578cfa761382"
    sha256 cellar: :any_skip_relocation, monterey:       "f74864f9b3cd08a54b68feb404551f074d55acad45b9adcef324a374e96f16c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f0b36f97771e718c430f24626cc39e64d19fed8b7dfef3718e47d6ac7a36d3c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion dev --yes 2>&1", 1)
  end
end
