class Lexido < Formula
  desc "Innovative assistant for the command-line"
  homepage "https://github.com/micr0-dev/lexido"
  url "https://github.com/micr0-dev/lexido/archive/refs/tags/v1.4.tar.gz"
  sha256 "9a6bb4197566c3455bca50028cbff38d5d301c918ba1a6ac84dd246fe5658b16"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bbd4f51a9d3de978b761f804462eec92c135101840cd7f1f301f0bd8ef83e817"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0281c0bb711542db286d282a101c006ee34e304ea19014ca04d8316b45f79f16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9240e852d20487a1be70d0919ea9b146f21967a1f723ba537b2f9359ba15d9f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e4480b11b1f65ced08f64b6a1aebd37f9e19013247dcc2e2e1c038f36ed8a75"
    sha256 cellar: :any_skip_relocation, ventura:        "92206d8fd677a9573c7cba78c433f798130d32c62b7ab6ecf0f041d6f83e8907"
    sha256 cellar: :any_skip_relocation, monterey:       "e15870a356ed546fba9040aa27aa4fe5dc9685d5cdb4cbd277f2bbdf3dcde120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58f92240428d5da4ab8590afb3cf125674f887f7b2dee6af7445e0d45beb31b1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Run the `lexido` command and ensure it outputs the expected error message
    output = shell_output("#{bin}/lexido -l 2>&1", 1)
    assert_match "Error initializing ollama: ollama not installed on system,", output
    assert_match "please install it first using the guide on", output
    assert_match "https://github.com/micr0-dev/lexido?tab=readme-ov-file#running-locally", output
  end
end
