class GoPassboltCli < Formula
  desc "CLI for passbolt"
  homepage "https://www.passbolt.com/"
  url "https://github.com/passbolt/go-passbolt-cli/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "327c82a82f3c60a088c20717822af136cb946091903bf15016a288137f5e20ba"
  license "MIT"
  head "https://github.com/passbolt/go-passbolt-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "493856850dfa1b7c78b5d3b276a0a26c51eea887e508078208e39a758fd6b1e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "493856850dfa1b7c78b5d3b276a0a26c51eea887e508078208e39a758fd6b1e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "493856850dfa1b7c78b5d3b276a0a26c51eea887e508078208e39a758fd6b1e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f5433ece6e4feebfc72b0f831c924d499d25bdf578858d321641015bcefd670"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee0f3501040a079a04b2b66258fdd7d442df4c0edf7748ba9a5a77933badf168"
    sha256 cellar: :any,                 x86_64_linux:  "6617d6d4904ce50c0037974ea27e1dc9fba52dc9cca3fd2dbce8599c535b7ccb"
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
