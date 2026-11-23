class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v33.4.0.tar.gz"
  sha256 "6c52e050de22b95c888d4305f8161ff690ec593ef7e9a82fc3dcbd99d4c09da3"
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
    manifest_sha256 "14415da08bb90ff8bcc0f6f08834093e3a47b451dd8576356fd007c29e5b4337"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aeee581cf7474d6f3fd2dc14dff0fd43356f473139642eea46b69c4b7444cf50"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1adebe6250c7e127e0245f05dbb2ae850fe9b21b759c406619df11e063cc703f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a12ff1c7a9e1b39e25a5e2f7f0c77f7ae03f07832e788eeec5adc0a1aaaa7b43"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "943fdb9d619f395c6399bde7c127ef4425733d16df122f24969cb333e6cc6185"
    sha256 cellar: :any,                 x86_64_linux:      "e3e8042110e8b00472662b5986cb3de7e54cfba47e64be74c913e74d2e4522a6"
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
