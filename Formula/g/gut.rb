class Gut < Formula
  desc "Beginner friendly porcelain for git"
  homepage "https://gut-cli.dev/"
  url "https://github.com/julien040/gut/archive/refs/tags/0.3.2.tar.gz"
  sha256 "49431ba0d24f9abf4c7cdbdf1956d2b6e70e16f955b5bbb70d8d8f4b8a5a48d1"
  license "MIT"
  head "https://github.com/julien040/gut.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5b8e5c4802862410954c0d1d18f5bfa76386573401482e378c0a4013e1423dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ffd25ab7b96ef2951a298214af160e7beb7e0079019bfac20f398bec5a42ce0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "993f5e0250aa0c86e7f439a332093c1e3384fcc5fd3979ba09485d0816947dc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0c4fba2fc790008bd0813b2313e81f75e2d02539e38f09141ee4082c5cafeb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e61dc52c2aecadc43b95b5a2a1e3c4b278ac6c182b37d989e81af5bdf162847"
    sha256 cellar: :any_skip_relocation, ventura:       "c0bf2735f14841209395250135915692de7df22bafe1ad32e0e9d2f47c5b7ff5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4de7f052481f406eda6c1bfa8b8cf1ec54b73e476107127fe66927f3e09f3e1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41e669eaafcb962c1f07cfe0daed82e5a7342d017e8c0160059498c168db8d35"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/julien040/gut/src/telemetry.gutVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gut", "completion")
  end

  test do
    system bin/"gut", "telemetry", "disable"

    assert_match version.to_s, shell_output("#{bin}/gut --version")

    system "git", "init", "--initial-branch=main"
    system "git", "commit", "--allow-empty", "-m", "test"
    assert_match "on branch main", shell_output("#{bin}/gut whereami")
  end
end
