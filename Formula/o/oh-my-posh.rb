class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v30.6.5.tar.gz"
  sha256 "265baf4fa27fa22fac7136746485b58a8135cc342053bf2cc23a2baf34b881ea"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2f4580fd6d469627c7a8034ec1901dbd977c6c4aed7cfb05d1ff5a7b5af42f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ef766aa0cd4e8d722961900d290542e176182a738431091fa2c82bc82cd4460"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0b479d4968813071f5ee2eea933b9591012cef82d445648d47e449b2771f4f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0006256ab1803567b830d9aa27bddcf6b4a9ba1fe47938b83430e7653a80461f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f8b7c9c8dc4da856ab135c7e46251cea98a4b9636294e7ba63b097dc58596cf"
    sha256 cellar: :any,                 x86_64_linux:  "355302ff24a029fccb6ffe1b128e4a0f62adb39b98859540ef3eedd91d9875e3"
  end

  depends_on "go" => :build

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
