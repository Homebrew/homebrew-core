class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://minder-docs.stacklok.dev"
  url "https://github.com/stacklok/minder/archive/refs/tags/v0.0.38.tar.gz"
  sha256 "c5bb28bb4c3c71c81f40c2fc207114e67df14d6c31d15e2d73f78653c5bbc385"
  license "Apache-2.0"
  head "https://github.com/stacklok/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5d7ed8e0c764b48aff8fc6b13ab57330bafe1202183d26d07e4708fbe170318"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c96af8e4f07470e6b2b6c087a3a098d03ae31411690b0305e1388ef6b9e25ce5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f5eb327c135399051099f416b4c0222511a23bea5954081a38cb7e643347ea8"
    sha256 cellar: :any_skip_relocation, sonoma:         "a26c70937bff252cfcb517bcda79b2d98fc6332ae6fffa4ee988dcab6221600b"
    sha256 cellar: :any_skip_relocation, ventura:        "2b7ded6521c1bdf31bd98773a8e67af1d7d1f16fb5bca7242605e02ae963ce07"
    sha256 cellar: :any_skip_relocation, monterey:       "d9179b42d2f41ddcb7a57a5f4316e2eedb9b09d08a5c1b386afde53eecfe135a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c6228a54db8f85b0aae950aeb2caf1f2b21b96595b4bc76e3b11f3134a96add"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stacklok/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end
