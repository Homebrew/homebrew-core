class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.57.0.tar.gz"
  sha256 "09b6e4ef7e11f7a7c6bc0ca02cee59b74ce66d135ea0800b91a44213d5b8eb47"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fa1b35f6acceca0a46a9ba7e741432bea7cf7ff4c64f89fcc5de2976779ce62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fa1b35f6acceca0a46a9ba7e741432bea7cf7ff4c64f89fcc5de2976779ce62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fa1b35f6acceca0a46a9ba7e741432bea7cf7ff4c64f89fcc5de2976779ce62"
    sha256 cellar: :any_skip_relocation, sonoma:        "df8319660a1aa315749f620dbb4cf9ac4fa8b9d06b2d84bf49f0d9ad897913fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b4777b4d85d105378599e76517225d416124aa22004e63a1de7ddc13bba98b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79ee23eb2f7084fa3951f877d8c758de3d2d3b511a38ea5ab0bb7192927d07f2"
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
