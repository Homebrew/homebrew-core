class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/1.25.0.tar.gz"
  sha256 "c81b9937dac9b478032f17d9fe238ec7bf92865bfe885cbf343ef5c1e54cd26d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d44b386cdcb6397baf656c676b902054552fd6853ebe36e71a19d0ceafef192"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e8013fccfcffaf0e6a17ab40fb91fb3495081f5e7b4434242295473131c69d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "775b1270eef5f9a6e81ed321ad8871a444580fb976724520645cddd9af7439ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "cefd949de23f1aba626162c7bd6f4a1b38c07696194d85b95a038257b4713d50"
    sha256 cellar: :any_skip_relocation, ventura:        "5c7381adde4dfb1fa14583c7362ef6aac241347e1b17e1dbc83db926aa931df8"
    sha256 cellar: :any_skip_relocation, monterey:       "b6ab523ee0cdb5c1ba58bbaa24391fa44c6eb6aec200a61f9398b05209bbe3c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a344db57431940fee49ed91bf6530c5b9e0faf394d862819b8dd939b92d6d5d"
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
