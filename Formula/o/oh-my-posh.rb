class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.14.3.tar.gz"
  sha256 "73efd80f42ce532ceaf74fafd615415a7e72066a48c587bb00fb432fc3210df6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3653a0a54aeacee437bc473dfff3de23e1a44dae1a3d89d0a523033cdf16388"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33e493f1b50cdcc720392482b5a2507b9c99a7427265c72de30a8e3a37589544"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d94e3a8871b7a0e97ae8e4d27ef5aa670aaeeb40d9e8f998537cb3e1b87d298"
    sha256 cellar: :any_skip_relocation, sonoma:        "7538d1a74567c30789aadf0e91110bea9334282ef9341816d467b5c5985270ac"
    sha256 cellar: :any_skip_relocation, ventura:       "7848909bebb3e64fd0cb9b3abab58b6c97641a09d5ae5ce56a612a5d71cd55a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c454fe93ac523dc197c2e138a2be82b01b35797d9aae4c390e6414b3eb93f455"
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
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.#{version}\.default\.\d+\.sh}, output)
  end
end
