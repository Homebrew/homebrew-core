class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v32.0.0.tar.gz"
  sha256 "e4b17eb0f9921ec30526b60473e7dd5c3ceaebb054817203269189bf278198e3"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "115c2f505cb6a6821b50454c900583b748c02afea02ddb8553ae828bada34a38"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ba858625b12068a6f96f4769a71e7feb2bb1bdc17d59718ad23425bb0af0c48c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "62a2c6c9e804c95eca66ea699bbd6c28aa546e18ea9b0bdcaafcfe63cee11a33"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5fa8e8c91a4d422a4d452bb5624135bc91d453c9fdcab6e291559dbbeddd2e9f"
    sha256 cellar: :any,                 x86_64_linux:      "9b2e60615ced165c538b06cdd5d706b7571ccd58805be669a1b05f33497f3fd5"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "src"
  end

  def install
    ldflags = %W[
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end
