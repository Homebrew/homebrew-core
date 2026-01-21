class GoPassboltCli < Formula
  desc "CLI for passbolt"
  homepage "https://www.passbolt.com/"
  url "https://github.com/passbolt/go-passbolt-cli/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "0887d9c30b43db30d7386ebd7472ec39a38f3529b0aeda3eff0e619e388e8228"
  license "MIT"
  head "https://github.com/passbolt/go-passbolt-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15ab371bff165852c0bab0b33d2b77a82946a13f7f6ff04b87d6bf008c95314b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15ab371bff165852c0bab0b33d2b77a82946a13f7f6ff04b87d6bf008c95314b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15ab371bff165852c0bab0b33d2b77a82946a13f7f6ff04b87d6bf008c95314b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8011cb4a4f370593fc8255feecc4c8a043113ed521bc465c3e1ce5ecf9e7ca0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "938987882e5f1e1bd9c79983718ac7873f2eb4c6c4534a5daa7863ca52b0854f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88796c820c4cb4f3621bba8d1fa39bcab9db3a3382470a5457ad6cd9534df16f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
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
