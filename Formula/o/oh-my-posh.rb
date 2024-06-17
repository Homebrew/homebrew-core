class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v21.10.2.tar.gz"
  sha256 "fb2b821e2f0f46daead3defa54ad9db4ae119bb9139e7ecbf11b09f6b0fcd3eb"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5088edb30797e390d8586ba59ba1dd8b4e65752bcf44917089a23d50c0c714e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7d479ab6b9269b91c375f65d30a79a322a2026e5d2568404c055725ebe69841"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1efae84cdc0d8f15852456f8ec18bfec47876d36c615578284e2b15612eca53c"
    sha256 cellar: :any_skip_relocation, sonoma:         "45bbd676e5431926899c56882f951e5c3a0ed69302f6a24f7df860e46f677a66"
    sha256 cellar: :any_skip_relocation, ventura:        "20b556e48ff94ef11359215139132cd2db6f2d7804fce03ad56c9faeeb860077"
    sha256 cellar: :any_skip_relocation, monterey:       "83b4e63e54cef9b268d38666a17ba99b01efbfec9e12cc306e80b283ee9bd44a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09803b9ab0bcd9458fd438a87d7b92c7ac04b6dab6e86dbbc3ebc0c87f17df39"
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
