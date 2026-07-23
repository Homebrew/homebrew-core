class MercuryCli < Formula
  desc "CLI interface for Mercury banking"
  homepage "https://github.com/MercuryTechnologies/mercury-cli"
  url "https://github.com/MercuryTechnologies/mercury-cli/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "64c4edad351c243d98962ae85adacfdcc40acbf0e124d62741b452efe1dfc658"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3706c5ec74595c059081c29e959bcab2c74b389ca87e9aaaa5b5a276bc4541f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3706c5ec74595c059081c29e959bcab2c74b389ca87e9aaaa5b5a276bc4541f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3706c5ec74595c059081c29e959bcab2c74b389ca87e9aaaa5b5a276bc4541f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d908f0abaa908748e5a364822863b5c11a5a0479f5cd40959cd84e4798060ca0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6d5e112347750bea04b39b84accfe5763fbbaaa338ff5a44e94fd249a2ec5ce"
    sha256 cellar: :any,                 x86_64_linux:  "0502a94dfee7dd5c38600f7785c00fb5b3462868dedb7f8c36a3fcd43cc722c8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"mercury"), "./cmd/mercury"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mercury --version")
    assert_match "Authentication Status", shell_output("#{bin}/mercury status 2>&1")
    assert_match "Your dedication to modern banking has not gone unnoticed", pipe_output("#{bin}/mercury hat 2>&1")
  end
end
