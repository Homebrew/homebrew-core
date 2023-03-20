class Atuin < Formula
  desc "Improved shell history for zsh and bash"
  homepage "https://github.com/ellie/atuin"
  url "https://github.com/ellie/atuin/archive/refs/tags/v13.0.1.tar.gz"
  sha256 "c012ae65b7093954bc2d614633223f181261208ca282a409f245040f6ad976a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f234f62dd94e96f4b92c4c494ce64887b771e2868126b4b26db34793cee8f77a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c2ceae6902a6b950cd63dfe09d52c89092eaa7acedc7985ad0fd056c8c0a46f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e380dc4017d7788b4e8dae85fc3df3ad2646179a55a8b657766c8672ab5cf083"
    sha256 cellar: :any_skip_relocation, ventura:        "9b6ec1c49df7e5b4b5cb9cff569653945fc80bc8289489eb3df1c8cb1fd8579c"
    sha256 cellar: :any_skip_relocation, monterey:       "5891b343314ea2498b9265c6cdc02f42b47b7305a36537606e59c92cd3bd2eb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "129b8d69fee29850359f4f763621b79e08cb928ee9eaebf98eceea0c234326a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dde69b8144ab4583282b14cd37eb2e961a53277dc448aa59bd89e8731c36e1a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell")
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}/atuin init zsh")
    assert shell_output("#{bin}/atuin history list").blank?
  end
end
