class AojCli < Formula
  desc "Command-line interface for Aizu Online Judge (AOJ)"
  homepage "https://github.com/YuminosukeSato/AOJ-cli"
  url "https://github.com/YuminosukeSato/AOJ-cli/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "8558c5e7285b7d3cf406018018b6b637a3298f209cf1761455d4ad1d550d0e47"
  license "MIT"
  head "https://github.com/YuminosukeSato/AOJ-cli.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/aojcli"

    # Rename the binary to 'aoj'
    bin.install "aojcli" => "aoj"

    # Generate shell completions if available
    generate_completions_from_executable(bin/"aoj", "completion") if (bin/"aoj").exist?
  end

  test do
    # Test the binary exists and runs
    assert_match "AOJ CLI", shell_output("#{bin}/aoj --help")

    # Test basic functionality without requiring network
    assert_match "Usage:", shell_output("#{bin}/aoj --help")
  end
end
