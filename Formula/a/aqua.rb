class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.48.1.tar.gz"
  sha256 "c12122389e13dfb7868a7bc94424208e5010f74e20d1bf84b459bd1186372c63"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "affaf7b3bbac3925807407d2cbb3fdd24d2e965ef1600e6eb731c26d96e0c7ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "affaf7b3bbac3925807407d2cbb3fdd24d2e965ef1600e6eb731c26d96e0c7ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "affaf7b3bbac3925807407d2cbb3fdd24d2e965ef1600e6eb731c26d96e0c7ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "872f6bb9c33b753bd81df4220c42f3e065ccbf960c33214d698449219386a09c"
    sha256 cellar: :any_skip_relocation, ventura:       "872f6bb9c33b753bd81df4220c42f3e065ccbf960c33214d698449219386a09c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56a52e70b4be4f0586860a917b74da50101fc63a6138736475a8419792d46a9e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end
