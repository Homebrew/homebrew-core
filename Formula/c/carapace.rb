class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "b0d3f3d2c60acc48bce48d27810ca510388699ca1d5a4db2fd154a22797a601e"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e345369d82780e4c126a52837af7311bf198248624fa694abb293c9da49eca5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e345369d82780e4c126a52837af7311bf198248624fa694abb293c9da49eca5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e345369d82780e4c126a52837af7311bf198248624fa694abb293c9da49eca5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b4d414f22cf68aa31a591a3ff7363f73f85901c268615609e9f7b6b97df01d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c05544695406192363a6b2146b6a22c5b6f60fb063c5c91ba0936d6a680884cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5291bb017fef267db8df8d8c2b5823896d30b61a4804c050eb3ebd523d74781b"
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
