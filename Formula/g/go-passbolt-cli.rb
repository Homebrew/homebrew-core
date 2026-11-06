class GoPassboltCli < Formula
  desc "CLI for passbolt"
  homepage "https://www.passbolt.com/"
  url "https://github.com/passbolt/go-passbolt-cli/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "e9150c09cd05d78b666cfdbe8475dd0124bbd8a4719561411a9ec82ea1980893"
  license "MIT"
  head "https://github.com/passbolt/go-passbolt-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4cc014f014df5cefae49817268b7c8f802643665985edb91b4aaf3850632ddb6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4cc014f014df5cefae49817268b7c8f802643665985edb91b4aaf3850632ddb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4cc014f014df5cefae49817268b7c8f802643665985edb91b4aaf3850632ddb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e04d06ba5bde5e53be9f33dc955235a80b2413e0f7c50d8ae5eb25c688c7e3b6"
    sha256 cellar: :any,                 x86_64_linux:      "b1b34e864b59d21f3703978c40f5b54c03b3c51f3924b89d2a1baae6f5f13d4c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"passbolt")

    generate_completions_from_executable(bin/"passbolt", shell_parameter_format: :cobra)
    mkdir "man"
    system bin/"passbolt", "gendoc", "--type", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/passbolt --version")
    assert_match "Error: serverAddress is not defined", shell_output("#{bin}/passbolt list user 2>&1", 1)
  end
end
