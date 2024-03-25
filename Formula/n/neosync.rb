class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.3.65.tar.gz"
  sha256 "145a335a2d7a6da8086ea6e342e7f8724d872394095887c94735655a4a757123"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19d77bb3a025deed157156b3b2960181e26d24a4f5fc2d042c11a853b427558e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26e4c4ee8d6d8a8b5323403b4e6d2a2fac2ea0dae91cd2c341881c5e3fc574c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62e06ce860c7014f73161dd853f9994317e545841802b136d9e9476c12091d09"
    sha256 cellar: :any_skip_relocation, sonoma:         "aec5d9de37ab93b766ee9cdc2aacee757d546d6149f52532f0a3b1c3933d10e6"
    sha256 cellar: :any_skip_relocation, ventura:        "7bff4c7f25554723ee96df89ab95267357434125191631faa259399305ae9434"
    sha256 cellar: :any_skip_relocation, monterey:       "392d98246c1ac9f1d28d698451eb7c50245f9941330a59aed0393d2e27290a95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7a69ff41be2d840c909e449d787a4e5de126c9b233ec9ebbc0beef6a3057c46"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags:), "./cmd/neosync"
    end

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
