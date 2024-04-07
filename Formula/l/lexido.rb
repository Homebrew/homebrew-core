class Lexido < Formula
  desc "Innovative assistant for the command-line"
  homepage "https://github.com/micr0-dev/lexido"
  url "https://github.com/micr0-dev/lexido.git", tag: "v1.3.1", revision: "36f02d699f2709f0bd51a5f119e0670845b4ad9f"
  license "AGPL-3.0-or-later"

  depends_on "go" => :build

  def install
    # Build the binary using the default go build command
    system "go", "build", *std_go_args
  end

  test do
    # Run the `lexido` command with the "test" and the local argument
    output = shell_output("#{bin}/lexido -l \"test\" 2>&1", 1).strip

    # Check if the error message indicates that ollama is not installed
    assert_match "Error initializing ollama: ollama not installed", output
  end
end
