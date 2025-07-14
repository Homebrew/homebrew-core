class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.68.0.tar.gz"
  sha256 "3501d5d2fc112130633e97e95b53625a2ae0b3e0415e97019843685e940b8380"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56f8d2c79a8a82cb8fb583c292625beea1db373ea454d02efab68166e783618b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56f8d2c79a8a82cb8fb583c292625beea1db373ea454d02efab68166e783618b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56f8d2c79a8a82cb8fb583c292625beea1db373ea454d02efab68166e783618b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1243dece42b871b756921b4e7a13eb83455a4b337b9c2af8535c61f6396dca9"
    sha256 cellar: :any_skip_relocation, ventura:       "f1243dece42b871b756921b4e7a13eb83455a4b337b9c2af8535c61f6396dca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95737d0e95c4fe7a7f47522560886f867f3d45fe369abfbae0e90a10bb53b5ce"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dependabot"

    generate_completions_from_executable(bin/"dependabot", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    assert_match("dependabot version #{version}", shell_output("#{bin}/dependabot --version"))
    output = shell_output("#{bin}/dependabot update bundler Homebrew/homebrew 2>&1", 1)
    assert_match("Cannot connect to the Docker daemon", output)
  end
end
