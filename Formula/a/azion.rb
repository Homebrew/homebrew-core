class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/1.28.1.tar.gz"
  sha256 "05a8871d30c0f37eddac2544d943f77a3211b81429eacceea0e4d497333967df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6a102283b655cdb19c6819a71d64639c3aa10b8a0095a89d593826b7aabc064"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b0d0747df0264ffee47e01762aea6842b803673f41585ba26b67bd1d38a358e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6a9482c3abdab88dd30381f36d653760328f679b16f187061e61389c4893992"
    sha256 cellar: :any_skip_relocation, sonoma:         "f22cf6b120d5b15e9eb8c5037734633c7cc6d4e45bd8cb670c65358e275224f0"
    sha256 cellar: :any_skip_relocation, ventura:        "8091707f136e32e634c5c1db466c6567183b43b90edc139d92548b1a149bfe4b"
    sha256 cellar: :any_skip_relocation, monterey:       "0a2689e9f54004801b1a1f7308d86a64fcbc8e811a2fd7249db5baf031249ad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af589746722a370e5cbd2029ce87dd4a2d18494956c5a8b9ebe48caae32bef50"
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
    system "go", "build", *std_go_args(ldflags:), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end
