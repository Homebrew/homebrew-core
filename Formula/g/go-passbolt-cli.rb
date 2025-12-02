class GoPassboltCli < Formula
  desc "CLI for passbolt"
  homepage "https://www.passbolt.com/"
  url "https://github.com/passbolt/go-passbolt-cli/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "4e88aa088b68a7101ca89a97184eb5427aa9b70d52df077f7d56c2ff3672fe06"
  license "MIT"
  head "https://github.com/passbolt/go-passbolt-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2b9012192a8c65f1ef74f37eff46255f2735b9f9447ce6cacd593521662c577"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76c8a1220e7d1fcac1d8dad53d317b0b384bb36a4d83abfda0185589cccd8141"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76c8a1220e7d1fcac1d8dad53d317b0b384bb36a4d83abfda0185589cccd8141"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76c8a1220e7d1fcac1d8dad53d317b0b384bb36a4d83abfda0185589cccd8141"
    sha256 cellar: :any_skip_relocation, sonoma:        "18c3ac460121631899b078594d6082dc038b72492232ad4640ca70712c1f2784"
    sha256 cellar: :any_skip_relocation, ventura:       "18c3ac460121631899b078594d6082dc038b72492232ad4640ca70712c1f2784"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c175f6379a3a319af84ed91d21c30d0525847c5adf8f7da7040e4154966d0136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2547a6b87ff2587b9e75f2a3b54317c25634d2b1d76656ddb2e93f6bfa978003"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"passbolt")

    generate_completions_from_executable(bin/"passbolt", "completion")
    mkdir "man"
    system bin/"passbolt", "gendoc", "--type", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/passbolt --version")
    assert_match "Error: serverAddress is not defined", shell_output("#{bin}/passbolt list user 2>&1", 1)
  end
end
