class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "309c886e80c573f849ec65d5651ec633f0e72ec7e4031aea9eb2fed93b0720d7"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d6ea08a7eb411f54597c886649adc0ed44dcefb11a2e7278dc8b585187c5013"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae9451963d94076e50e9618583274c5611f5419cfd088fbe57339b870fcef286"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb74043257f4e3a50d63d0ec44af4d1007c7e4fb305369140a341ca09c5d32b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdcc276b4c6f9cae9436468d04a8ca4a10ddf68e55259a7b895eaafec43eb44a"
    sha256 cellar: :any_skip_relocation, ventura:        "902da9bf5611c326abd369f4b45a2cb54229cb1b4a2f0fb81634c9f758c909e6"
    sha256 cellar: :any_skip_relocation, monterey:       "e11f64264a9373005637bc8a1c22b3e45ab47350503512898d60c21728c651d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f6c971fb5f2bb65669fbaffa9b60823063ae8dc54e276412fcdf01c8d98821e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/open-policy-agent/conftest/internal/commands.version=#{version}")

    generate_completions_from_executable(bin/"conftest", "completion")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system "#{bin}/conftest", "verify", "-p", "test.rego"
  end
end
