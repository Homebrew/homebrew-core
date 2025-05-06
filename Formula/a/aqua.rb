class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.51.0.tar.gz"
  sha256 "1ebbd9214dccdc4c61654d897d247f1dc138a41aba41b0944ead5ac876620e43"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dac68c4a7f7267e838e3ffcc988a8bb7d718da2d2b5f468735379cea20dbbf96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dac68c4a7f7267e838e3ffcc988a8bb7d718da2d2b5f468735379cea20dbbf96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dac68c4a7f7267e838e3ffcc988a8bb7d718da2d2b5f468735379cea20dbbf96"
    sha256 cellar: :any_skip_relocation, sonoma:        "4713a0f66fa1332c77d20e798bf4bb6740f20d39ffadcde8b1fa42aee1765bdd"
    sha256 cellar: :any_skip_relocation, ventura:       "4713a0f66fa1332c77d20e798bf4bb6740f20d39ffadcde8b1fa42aee1765bdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e7478356e0a95c2cbadbc3eb5cfa0a96606cf2a64e2e08316f070f0d8c8f2a3"
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
