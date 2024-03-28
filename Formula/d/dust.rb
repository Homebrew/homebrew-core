class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "34b72116ab6db9bdb97bc1e49dadf392a1619838204b44b0a4695539d54ffbe8"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "409ba5dc4ec439ba9b30934286f826a4e4bfa370189be147550f5e37eb4bc625"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2525befaf8dd0f20bb8a0421f789177dc14162b098d5c40374529758aa69e058"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17b9a48d398d0965a0cdb52dc9ae08325b7691a1c62f3baca9b7763ed3c1a725"
    sha256 cellar: :any_skip_relocation, sonoma:         "65c18c762ca90dd1a71a319a707afe385fd27eb44575552f87a6d99fdde96fca"
    sha256 cellar: :any_skip_relocation, ventura:        "bd05918ff8654836fd4a1a4503743b3f28b9b644a3fc2c4f387109dbea69c64f"
    sha256 cellar: :any_skip_relocation, monterey:       "4d3bd0c11749214d081f52b6044960f7a4adc7262a01a6c38c0ce18740d987ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee66e159d9a8b9ad543346d7e68221061d9ee4232ecf6261ea3d116f38751be0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/dust.bash"
    fish_completion.install "completions/dust.fish"
    zsh_completion.install "completions/_dust"

    man1.install "man-page/dust.1"
  end

  test do
    # failed with Linux CI run, but works with local run
    # https://github.com/Homebrew/homebrew-core/pull/121789#issuecomment-1407749790
    if OS.linux?
      system bin/"dust", "-n", "1"
    else
      assert_match(/\d+.+?\./, shell_output("#{bin}/dust -n 1"))
    end
  end
end
