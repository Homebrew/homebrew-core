class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "7d110560caaa61a5c0966ce8882037b189128b212a83402b0c653d81bd04544d"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c038908e04d71c09f34fb9ddd78b0f2b65672d7346b932aed34829c946359d96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c038908e04d71c09f34fb9ddd78b0f2b65672d7346b932aed34829c946359d96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c038908e04d71c09f34fb9ddd78b0f2b65672d7346b932aed34829c946359d96"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3cd92cc7bedf6104eaabacbc15d42a2371fb031914378c9da81226454dc5c22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "453c0369d49e7fddaf2c0a40d8b756ed55eb7a738a7c407ece3cc1fdcd97d54a"
    sha256 cellar: :any,                 x86_64_linux:  "b20c45d84f7a6f9e9b19c2393ae3f98e323887f100d0904c65e0f82e9cc60a8a"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end
