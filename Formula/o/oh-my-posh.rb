class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.14.0.tar.gz"
  sha256 "67fcbeed224efe8682ec144b9ba0e6bef1d8ff65f77c6fbbc4340d9b9017359b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ac4b76bc1e1fb0e9de198b4e113ce25176edc168287139b1d15c566c8d71a7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b50ac525c0cf23297421427ce8aba8a04966d05fc32170f2bb6ad1b6662df43c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63bc8e362815080655226e5255c0358b441341fcfe293f87743949ee7fc5cb11"
    sha256 cellar: :any_skip_relocation, sonoma:        "d41282b6ef860c3fbe2d232e908897006efb601546fe634ba6251fe36fc9ffdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "accf159b0e2c58703eb1e298445c5c992d01d14823c987aadaa607f416052826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fa5529c8bcb1f7db5ad02f4a6ef300178b0f11985bf09d298680e541c6f2abd"
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
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end
