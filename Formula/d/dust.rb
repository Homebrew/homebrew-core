class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "e72f539ebe2f30bd85f83f8efd87c70c11e27126eeccd93560d94d2f01e153fe"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d163c5547a7c5ba1ffe9d46f46960482209d86cc6fd5483f3022a1d3405a7cc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "621c243814d1e4d3e87ea1b2cee661980294d6d882c9afb777eed2bf71559d51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbb67ab86f86926b89cdbb9e3a123d51a013f481ee63e091c22ca7a1e36d5cf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "37780adf643823e268338a89dfeef853cda65dba6dcbf1785777571ea6527a75"
    sha256 cellar: :any_skip_relocation, ventura:       "873d1cc8d0dd028659d2d7964f21263904f37cdda1b7f4693c2b085b8f688398"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37f41386dd40259af006ae5fefae46445a2964b3e2a675ddca84789573304e4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9530581f89f462448989c9dce9234f963fbe696dd410509192d29d76048d061"
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
