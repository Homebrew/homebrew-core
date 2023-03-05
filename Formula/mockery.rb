class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.21.0.tar.gz"
  sha256 "2334e0671201f6ad833e4275cfe9e75360bfb9d4eaa944f97e6d34a359d25b37"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87109a90de18ebec23153c997fa3faf377947b74a6d9e8f4766b4719bd535e13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "131fd789f0f9de077b50f79bf235e2cb4bf0639cb4e6eaf52685cca26a8e838d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4290cf1743a51057aaf609d222676b7c599defe2e6e92a30d65e91b60248575c"
    sha256 cellar: :any_skip_relocation, ventura:        "962a1b346e3ad138da348b5c8e821fa36ddcdbde5365459db03a98aa1648e06f"
    sha256 cellar: :any_skip_relocation, monterey:       "a5f8761b7d89bcb4f081305425a90a7fdea2e8a7c7ecf2f28e09683c2f0e9edd"
    sha256 cellar: :any_skip_relocation, big_sur:        "fffaa96b3e31a176d93383f654204078ebda3d9e0084f417f3582dc359e73784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd0383050c70ee73df921cb7d33805908d76c7fa2983bc1fc561f857dc05c22f"
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

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1", 1)
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
