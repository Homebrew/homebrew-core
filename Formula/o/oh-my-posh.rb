class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.17.1.tar.gz"
  sha256 "e8900f9b6e98b2cb9bdfb55488c74f580f004938ae60c2d4e15ba1f412ad1504"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bccb16801f48b687af5364782dd51d6c7b35411842862ca957074cee60958e04"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c597ca1220809da41f1f19a317e98158cc20c3683241e6aa688cfc3010ff218"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f55dfdda9aff713e05120bf29253f38b41d3ce646e1f087706290d5257be6c12"
    sha256 cellar: :any_skip_relocation, sonoma:         "513e2cfb86207f72b7019107d672e56f0dc19a5ccc274c243f303a778dde55e9"
    sha256 cellar: :any_skip_relocation, ventura:        "2e18d4582e79c15838a3d47518f6156fb3c9980457cbc839dd2be08518f1328a"
    sha256 cellar: :any_skip_relocation, monterey:       "6b7823441682a7c14583c721fabd45bb4a0a5759350f4f21e3b2d5102b52e1a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8059dd3aac90db9e5c4cda8364587f4133976e8257e6d54c63798ca965ff1f08"
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
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
