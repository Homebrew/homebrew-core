class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "028d4dc977dfe18e34097ce1c07c082c6647f3fb55e0a78ccdb78724f183a506"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78b52f1c163fff84562f97cf7c01f9bfff7b8b88799033505777748028318e08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ad7565dc6b732d0f9f39bcbf3ede70b9e0cf9aa10b7fe9b9abc097adb8cde00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "861ae9003172c7ee205176572a0255f272de0725b0cf25a9ad45f622dda4e146"
    sha256 cellar: :any_skip_relocation, sonoma:        "060b3c7d777464744c40ec7612630df54537053caf6ae0a439ac4d625db195a0"
    sha256 cellar: :any_skip_relocation, ventura:       "3254ca0a707739a0b636f6d1c9b7061261fc2f89f0bd9195d1dd62d1193eb7cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "339c7e931c41ddad555a8d6408cd9eca43cc806581f9cd1d205c2ce1ab273375"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
