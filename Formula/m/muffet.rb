class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/refs/tags/v2.10.8.tar.gz"
  sha256 "b9af96eed0a43a3fa98d33b8eac320581b5ccae67d224a6df151b6e110e03f14"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e56f4d50c60c38899dac2ccb9fd247803dfa695a547d1f084955c7fd93e751d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e56f4d50c60c38899dac2ccb9fd247803dfa695a547d1f084955c7fd93e751d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e56f4d50c60c38899dac2ccb9fd247803dfa695a547d1f084955c7fd93e751d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "694f6195e8501a68423a05a0f882cd485d5f44385f4ef67ace5a6f9e4420b328"
    sha256 cellar: :any_skip_relocation, ventura:       "694f6195e8501a68423a05a0f882cd485d5f44385f4ef67ace5a6f9e4420b328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54996f8a1026d9e4be730a91dc29138a770989dc61ed8374556eb1cb64cf9968"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://example.com/",
                 shell_output("#{bin}/muffet https://example.com 2>&1", 1)
  end
end
