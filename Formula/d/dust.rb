class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "98cae3e4b32514e51fcc1ed07fdbe6929d4b80942925348cc6e57b308d9c4cb0"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d645dd72a1c5a287d8b5dec369bba3c83a75448171b2cc1724e07363ded70f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "837fb55fcb02c99efff5b19c3b50aeff323ec54125716c1506b18f4e821b32d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb9727b495643fc9257406be8f4d3daf657aa3bebcfdcce3778e1c0c6223426f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1726e1634c2cdff9c43bdc513c810608050ff85e23c885ec349a763828172fac"
    sha256 cellar: :any_skip_relocation, ventura:       "8158c5f5f51c1137674ce1142429019dbadf4b99ad404af4ddb5c89645e3c598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb96e198b0a3bb3cafe0c867b835cb552c91f57ad930658923561137bb0ede60"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/dust.bash" => "dust"
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
