class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.85.tar.gz"
  sha256 "5f544e08c18e20a82706a5a383e97278e96adfd6410b98defc68d74333be8cc2"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d86ef9edbe0d1d53a90d2ab68862372193302d642812b12077ab373a360d65d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d86ef9edbe0d1d53a90d2ab68862372193302d642812b12077ab373a360d65d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d86ef9edbe0d1d53a90d2ab68862372193302d642812b12077ab373a360d65d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "264f3a03c012ea92db5dbb40ddcf622a267f96d919f46c83367eecac3a75f159"
    sha256 cellar: :any_skip_relocation, ventura:       "264f3a03c012ea92db5dbb40ddcf622a267f96d919f46c83367eecac3a75f159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c13876fbf9586f7bc1e47c60dd0aae96b335bfb5fb535d2c7183048cd18c5c1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli/cmd/neosync"

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "ERRO Unable to retrieve account id", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
