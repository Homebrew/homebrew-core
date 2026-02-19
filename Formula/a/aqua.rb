class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.56.6.tar.gz"
  sha256 "496f2538b79cbc2da3e093ccaa5c5b00c10aea188377b8a9e04df7e9f03bcdc9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fe49f7af083ae678baed00d899e898185d4f2d9e8b040c97d05b32b5ac9a4ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fe49f7af083ae678baed00d899e898185d4f2d9e8b040c97d05b32b5ac9a4ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fe49f7af083ae678baed00d899e898185d4f2d9e8b040c97d05b32b5ac9a4ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "414eb24e5d7de32ef6915f141706c13b870fc5815cb6e25da63a8798ec52b168"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "090faea559be9a16fe5878dc0da0716c918bb75807e9306dd9e90836602f1895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4784d1a4dccacce1ba0bb5e73bcca829788e2fd052125ffb918c903d2256992"
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
