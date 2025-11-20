class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://github.com/Permify/permify"
  url "https://github.com/Permify/permify/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "1811005fc8b03e1f73811dde5a508458b2418a3c0267b95e55e68a57e573ef01"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9496a9472edda99e0fd87484100a98fb40b1ebd85c5c33329dad61c4eb9373dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3b24861b2e755f79d76c857317ee583b2a2a2aae58d94573e390b600745541b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f26873a6fe62c80f00866b08548c181a0d141418b128c89223bd7b88c566bfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f987d6d935e59135cd619da53c741d1ff7f1fc143303911f4dfc1445e0d860b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b7d4836fccc89850fd1998e49460e0d783a35feabaee59c837f65a3540e6fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cabe5bb0c6006812a7560e1202549966c4cb1c7a58c55dec22249adc4725f87c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/permify"

    generate_completions_from_executable(bin/"permify", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/permify version")

    (testpath/"schema.yaml").write <<~YAML
      schema: >-
        entity user {}

        entity document {
          relation viewer @user
          action view = viewer
        }
    YAML

    output = shell_output("#{bin}/permify ast #{testpath}/schema.yaml")
    assert_equal "document", JSON.parse(output)["entityDefinitions"]["document"]["name"]
  end
end
