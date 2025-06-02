class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/refs/tags/v10.2.0.tar.gz"
  sha256 "73329fe24c53f0ca47cd0939256ca5c4644742cb7c14cf4114c8c9871336d342"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "288860909de7a2e91ce05b6bd85f7e460ab8826817a1656fafd990d607e3d459"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "103924cd3cd77fe919b4cc277ca6bf939dd2db284b0b5503c609046142c106f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "642e0e04cca95682808230f796e883c56483c3cc1667236139273461cc2ec99a"
    sha256 cellar: :any_skip_relocation, sonoma:        "83e317dce0070b68cf66c7794a9da7fe1f9d00d9f2bc2d94f5e49bc311dbab3f"
    sha256 cellar: :any_skip_relocation, ventura:       "0621b915f7f793aa769fc6708a2e1c2a38864998492af57feae774e986e7bf2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bba21d80a06ee8e17144cb5c3a231cb73179daef815fa050390b74228b966d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5f6efbd469e33cc32ab15dbebc0e78415ff662d827ce4a200f2ded78ff5143b"
  end

  depends_on "rust" => :build

  conflicts_with "fdclone", because: "both install `fd` binaries"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fd", "--gen-completions", shells: [:bash, :fish, :pwsh])
    zsh_completion.install "contrib/completion/_fd"
    man1.install "doc/fd.1"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
