class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://github.com/k1LoW/deck/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "33e249eb4ac73a450507fa92f14c41f8b962eaa8af9b08ed338041ab293dd555"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ba990c35a455a559a85b41127c8ebe2c88a806bfaa394e930303ec5fd9c80f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ba990c35a455a559a85b41127c8ebe2c88a806bfaa394e930303ec5fd9c80f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ba990c35a455a559a85b41127c8ebe2c88a806bfaa394e930303ec5fd9c80f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3e5e27c22c7cf2ecb952a83f8d015114fd6e3185ad535134dfda39163a27908"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8d9c68e323849b9820b7aae301d33289644b0309ebd40b1be1798b023eace6f"
    sha256 cellar: :any,                 x86_64_linux:  "00cba1339883b96acb4fd0361c058187866f93c132153b44c75bfebc304e56e3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/deck"

    generate_completions_from_executable(bin/"deck", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deck --version")
    assert_match "presentation ID is required", shell_output("#{bin}/deck export 2>&1", 1)
  end
end
