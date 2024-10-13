class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.54.0.tar.gz"
  sha256 "ae496c65e4f947cca1251c9f786fbcc1e5e1a079af7fee08b893265e69d39295"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4add3d15ddece3726d1bb617becce4e7f2fe5485da07a8de1b1e9636b4f76227"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd7e038445aeda191a9a83a923c2e9f9c6c3293e70b99d9ed80cd2b289cb69b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8310ed4fa7c2e8f346832a29f517b0197bd3d723d1f8f1c4d7b76d0469ad7988"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "facbad6559366226753da4aab32209cdfe010a2c937095a1c3e40dfe4c17f34b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9172315452a179f36a0004ae3efe55b6186f2b4ca71641af105254cbb4883d9"
    sha256 cellar: :any_skip_relocation, ventura:        "3b3a3b88843ee47759a7f4b9d342443125ad9d6c47db4c584fbfddc9ded46ed9"
    sha256 cellar: :any_skip_relocation, monterey:       "a16e641c625d0fffbfaac267226ad5d7781f8c463393d04c52862f29d9bb98dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "279f57639446189df0c1a2d44c0a935cca45d28e523786a45558f75fa8fe3245"
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
