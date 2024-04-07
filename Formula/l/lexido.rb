class Lexido < Formula
  desc "Innovative assistant for the command-line"
  homepage "https://github.com/micr0-dev/lexido"
  url "https://github.com/micr0-dev/lexido.git", tag: "v1.3.1", revision: "36f02d699f2709f0bd51a5f119e0670845b4ad9f"
  license "AGPL-3.0"

  depends_on "go" => :build

  def install
    # Set GO111MODULE to "auto" to enable Go modules
    ENV["GO111MODULE"] = "auto"

    # Build the binary using the default go build command
    system "go", "build", *std_go_args, "-o", "#{bin}/lexido"
  end

  test do
    # Perform a basic sanity check
    assert_match "Lexido Command Line Tool v1.3.1", shell_output("#{bin}/lexido --version")
  end
end
