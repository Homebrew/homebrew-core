class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.100.tar.gz"
  sha256 "a61e1f2940a9367d72024ffe5bf0190f1c526ad0256e4e4ce0e61e671582edcd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7c7e6d8fb1634bdb053d884e6c5f47a54679b4356f03b576d4ea95acff3aec9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7c7e6d8fb1634bdb053d884e6c5f47a54679b4356f03b576d4ea95acff3aec9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7c7e6d8fb1634bdb053d884e6c5f47a54679b4356f03b576d4ea95acff3aec9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c8312cdcf57867da80dc210c38ce097ddc08b2173e6383ac5699dbfdf3476ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "367bd116608c5c96fc296c8741fd1667e80be9a6bc4791fb01a683130eb11576"
    sha256 cellar: :any,                 x86_64_linux:  "c9e09f9c86e6e8c451d1bfb0609093513fd58b430e8dd8b22443ebec9c78abb9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end
