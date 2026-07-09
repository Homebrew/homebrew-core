class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.60.1.tar.gz"
  sha256 "96a9ef64b6501822b42a4ef136c2af61e35dd374ace3aff23087048a91f8a11c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d45485dafa850339f096237268c3c5e79f0df126839d1dc24437fb1c7114ce0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d45485dafa850339f096237268c3c5e79f0df126839d1dc24437fb1c7114ce0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d45485dafa850339f096237268c3c5e79f0df126839d1dc24437fb1c7114ce0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4463c159da6e622fb84fb63e1fc8acf2ec000565dd4a783c689b938f5f4be98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f976866dba6b00d21a16b50d6f5edb4e883876eee86594789c3b080875a27bf"
    sha256 cellar: :any,                 x86_64_linux:  "009ac4a4fbc4299f447252981c1074513d97cac64a6a810871e572a0018e649a"
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
