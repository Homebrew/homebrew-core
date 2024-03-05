class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.3.53.tar.gz"
  sha256 "d035bbc44e36bec3ebcde2cfee2d1fb152807ac0811dee1c7acfcb17a5eee67b"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7f09f2ad5e9f7492043b754afc6b4f5e3761a3b0c278d18522fd8f2e8608dd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b2fbc400d6a8fc1f90506375be32c9b3d8278ad311580b6e4fc363098f0efdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd7628454072f6688eeb61b39cb93964bd812660861a17be05f33566510f1e83"
    sha256 cellar: :any_skip_relocation, sonoma:         "0204228fd5f67a25e7ec6310a5f7993d9cc40ca583bacb857f5e94953b855cdf"
    sha256 cellar: :any_skip_relocation, ventura:        "f9cf54a85206741e17cdb72541826ee2f7ffcdc7cad1129b5f3638c017cecd40"
    sha256 cellar: :any_skip_relocation, monterey:       "ebbac7a8c7b10b3c42e54becc397d2e3c2e5d2cb7a36612d2ffe233d549f74e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "192da9cc47d4bb1091ba2f5084a575666d7f0749bce84dbc023efd15b7c136d7"
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
      system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/neosync"
    end

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
