class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.10.0.tar.gz"
  sha256 "eec16214711e2fd73385a999296d81afcd009dbe97626285d4f6729ff31a59af"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39627c07933dde810d1dc5e6b93638aae29ac24244ad07565e8420e6bd478ca7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6e4a7f897c8c37c4280bde9f174767acf5713ab4b279778c8148d04a9eaaa16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b644e6aad6b6af98b37f76a37d23923b88a3425dd20207776103780580066b0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "22b62595db8a8afec2357bd76031cfdc415a0d9872c09eaaf7e77b78e9bcfe22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e490246ca409e006ce0482fdab9085f7d4128f4951dbebee09ca34537468c7fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a2b8af6aa6046014738e43a065a45a66796e68369fcfa79ca590eb761f56b8c"
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
