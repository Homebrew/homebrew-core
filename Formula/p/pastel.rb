class Pastel < Formula
  desc "Command-line tool to generate, analyze, convert and manipulate colors"
  homepage "https://github.com/sharkdp/pastel"
  url "https://github.com/sharkdp/pastel/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "98639ae6539da5a4c20993daa559ca2d19dde63b601bcb29bb0cebbf56b1ac08"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/pastel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5642321f2522826ff4cf9d82194d371a4da24ce6d435192b82fe015cf211de0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0556213373e88fdb97e99e25c87ebe6a7756d1d39211bb49e2d377b6efe445ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b902288152e2829b19c229dc3e2dfc6cffaf705d69c3efa8e606e83723f9ef2"
    sha256 cellar: :any_skip_relocation, sonoma:        "57535b707c2cdb6d3b28a1aa890b2bd4edc1e8f15a6981913fe3f9e3baa9530d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55af95886afc7eb7fa55f4da04f003af6e54cfe8e02da733d69d33310a26ca4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c227183b9d5a07b3160fc943db717c6361ca2014ca0eb5ec190a02ec2fab9234"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath/"completions"

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/pastel.bash" => "pastel"
    zsh_completion.install "completions/_pastel"
    fish_completion.install "completions/pastel.fish"
  end

  test do
    output = shell_output("#{bin}/pastel format hex rebeccapurple").strip

    assert_equal "#663399", output
  end
end
