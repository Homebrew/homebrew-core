class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.51.1.tar.gz"
  sha256 "1df4e2a7744763826ec3f11c2511d1dbcfdf068b28ac44fb110ba3f88e1fe4ca"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fbd1bb52700fe73e61f5526d28295887f3885d91a11a71a5ecd7ab4fa4e2e70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fbd1bb52700fe73e61f5526d28295887f3885d91a11a71a5ecd7ab4fa4e2e70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fbd1bb52700fe73e61f5526d28295887f3885d91a11a71a5ecd7ab4fa4e2e70"
    sha256 cellar: :any_skip_relocation, sonoma:        "2df9c1b09e01f7fd6aee6044b3ad94e669446e6001e403a9d1daeef48d95c04a"
    sha256 cellar: :any_skip_relocation, ventura:       "2df9c1b09e01f7fd6aee6044b3ad94e669446e6001e403a9d1daeef48d95c04a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1629a68a511194689ffb4e75840224c4cc6aea10405be42dfc395522cede1704"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end
