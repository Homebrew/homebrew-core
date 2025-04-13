class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v25.13.0.tar.gz"
  sha256 "879eff4f2f4fff95bfb8d1ea5debd20b1d5647d8cbc6e89bd0a34b801c76b533"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca14f33aac8ddc74a5840a8073ce44941f8f869d84572e624f14f4360e507f14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab4a5b6446d9d68aaa55975c0d37273d4a1b6ce1f827aa6fe59fe2a09de036d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db06a778896e043703bb313dab53f1f03b32a2c7963d289c11ed81a86030596b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a17ffc5d1e6a9a1d614876332f9ee266883122192ad363538205ca3e7e70275"
    sha256 cellar: :any_skip_relocation, ventura:       "04b02c57701fad3c546a4fc274af9188b6daec86fc16245c478d6bf362d3240b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbb135037cae98a07362915175a8d19423f93a6cec46f5d3f923b86c66c9a98b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
    assert_match "Oh My Posh", shell_output("#{bin}/oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
  end
end
