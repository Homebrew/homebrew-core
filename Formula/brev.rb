class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.195.tar.gz"
  sha256 "f3ceb79d49eae110b09bf2f9479586a326ba850d8c3160741ffcf78e40d7f7e7"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c632636893eea4fb13028693095a20d4668e32c4030f0015d435f809bcdfae08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0994bdebb5b04043e546f86742fc2542a73a9500fe6145266b6220e450d6c9a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b1ad47b2898bf81954efdca25ef1b864d71ed3c74b315c74adc083d77e82679"
    sha256 cellar: :any_skip_relocation, ventura:        "b1018e5bc98afca7ee0420789ed018b180661667b18c510d6200817c0aaafd16"
    sha256 cellar: :any_skip_relocation, monterey:       "2bb1d9b623e5ba07fe1aa0e560914b14699116be342782620e044bdfa776ea38"
    sha256 cellar: :any_skip_relocation, big_sur:        "e44ba9a4a21ea47b57d3ea0d3e9d266ecc151f5173464a875e1ea717f1ec70d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbfa083bcad0831ac37c4f270d572d8f0cec94f71825616915a3e28306952654"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
