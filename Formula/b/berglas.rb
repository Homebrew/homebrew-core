class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "2051c357f672ddbfafc10f4189e81f15bed849f141452737cd4d9adf72d58503"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "beb81e6cde2715d940c8a4e45c227f4567b911dd1e9761da30898a59202c7823"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "beb81e6cde2715d940c8a4e45c227f4567b911dd1e9761da30898a59202c7823"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "beb81e6cde2715d940c8a4e45c227f4567b911dd1e9761da30898a59202c7823"
    sha256 cellar: :any_skip_relocation, sonoma:        "d07d28cd51350bb08973f3ffa54853854a14acb5533839463c376efc3745f4d0"
    sha256 cellar: :any_skip_relocation, ventura:       "d07d28cd51350bb08973f3ffa54853854a14acb5533839463c376efc3745f4d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3cebca5f4a9f168a4a380d19aaec3dc1c02330623fde67d51c378058caf77f3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/GoogleCloudPlatform/berglas/v2/internal/version.name=berglas
      -X github.com/GoogleCloudPlatform/berglas/v2/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"berglas", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/berglas -v")

    out = shell_output("#{bin}/berglas list -l info homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
