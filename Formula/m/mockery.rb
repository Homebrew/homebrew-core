class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.34.0.tar.gz"
  sha256 "f979390679e3ecc80f41f6dabf964835f71ef1a683a09a68dfb86a66bac433a6"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ca2959a5f12bae97b3245ad2bb4a2bb7c8031e680062329e47bdd6066d26dcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13031e6ba099df354a70f113044aec9a7bd945ce6bf3b042967b2bc1833dafe0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d5283d861a9c75a8fc57bf4887e1159b9153aa1a68fedcc82ff191bb43d7f95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "821f5e1d684a7f66b246d9dffe14a6bf4950e101118c2f8f41fb7ac979174007"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab2fecc4613f67ba2618547c77f34471d718c7ad5056647823e52577dcb0ae78"
    sha256 cellar: :any_skip_relocation, ventura:        "62094f8400b5b0f5c069cb6b035d3e77d2301e6ff89c7bb115acf93955531442"
    sha256 cellar: :any_skip_relocation, monterey:       "2e3be33aac26ee5ba20ea08c8993cae8cf8da748759c69bf19e487fd83e2ef6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "677fa2fe8dcee6371aa2ecc456724fec4a96045ccd67747224ea56c44ada6eb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "675a36042b78bc9ddeac7c68cd9d16a4e688f1c9e30bb53e33e6286759e4cd70"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
