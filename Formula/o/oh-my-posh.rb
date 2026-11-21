class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v33.2.0.tar.gz"
  sha256 "ddbd44c65857e87fd4dd250f327a02a8312b9d307766a0695448c094331dc8a2"
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
    manifest_sha256 "e26032553fa00f5df7b63f225b3e3f2e110a74d15f82c26418767d05ee963b63"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "23c982d058ed72626b1fad4d31e3b946e952b5e768037c1a5b1ea1d67f221052"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0bd88b91f9530d526c7a54aa63e48314d7c4eea80c3731bb5c5b1cd8d741bcdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aba5493db3fe645a75200aba6718faeab3e471b35b856a1ac56aa539880e1bdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5b267ea67dec49cf75305e50a9002b6c2f43175e8b0580505ddb054b7e5b2001"
    sha256 cellar: :any,                 x86_64_linux:      "28d1b96b3fb1655289bb05abb6c7376b9117ad81ce45be88fd4d6fdd59885a31"
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
