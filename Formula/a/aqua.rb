class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.62.1.tar.gz"
  sha256 "717a397c7d075424cbdb5256234514f5677683afa153610428f241138a363741"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e74ea08e398731df1c477125b37f343dca32b34afb1416e128faa8be608421ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e74ea08e398731df1c477125b37f343dca32b34afb1416e128faa8be608421ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e74ea08e398731df1c477125b37f343dca32b34afb1416e128faa8be608421ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "85eea3e571a8db01f9c5ba75fcc4b14a8cc7ab2ec4cfc21ab4a42c893aae3439"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de4eec1f19b0584cb3f25bc5f70efd01715608dfff04b8cf75a6d9990b2fe029"
    sha256 cellar: :any,                 x86_64_linux:  "742acc1450fa79cf02ab24af6ab2ecf9cfd45229efafe406ffa6b70db093881f"
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
