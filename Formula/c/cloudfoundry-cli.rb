class CloudfoundryCli < Formula
  desc "Official command-line client for Cloud Foundry"
  homepage "https://docs.cloudfoundry.org/cf-cli"
  url "https://github.com/cloudfoundry/cli/archive/refs/tags/v8.14.0.tar.gz"
  sha256 "44abf756a7ced0fd6dc12d6cb87c26aac5b79a5c6a6871b7f57aa1864521d437"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "979ed2b67372ecf27e871ca4ba989d276337b4eb42e0469f6f165031d376b79d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "979ed2b67372ecf27e871ca4ba989d276337b4eb42e0469f6f165031d376b79d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "979ed2b67372ecf27e871ca4ba989d276337b4eb42e0469f6f165031d376b79d"
    sha256 cellar: :any_skip_relocation, sonoma:        "096615d910f2d95af59cea9df2bda5a8c330e96685fce9361e3fcd992675f973"
    sha256 cellar: :any_skip_relocation, ventura:       "096615d910f2d95af59cea9df2bda5a8c330e96685fce9361e3fcd992675f973"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13f87f8c6ed6cb74bc5c049ddd6364113ef9fbcc5b0bc8759d44d40a33b36c53"
  end

  depends_on "go" => :build

  conflicts_with "cf", because: "both install `cf` binaries"

  def install
    ldflags = %W[
      -s -w
      -X code.cloudfoundry.org/cli/version.binaryVersion=#{version}
      -X code.cloudfoundry.org/cli/version.binarySHA=#{tap.user}
      -X code.cloudfoundry.org/cli/version.binaryBuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cf --version")

    expected = OS.linux? ? "Request error" : "lookup brew: no such host"
    assert_match expected, shell_output("#{bin}/cf login -a brew 2>&1", 1)
  end
end
