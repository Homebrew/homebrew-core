class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "f36401daf3800ab1b52a0c07926262bae8e23b0e6c497a9d5077ae50022e6322"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c01a232c6ff4ea3fbb1e77630c5bc90dddbb28f8aa4bc6125a1fc157fbed34af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08a9648c4286e1f3de0151dabefbab125a13b5a5cc278ec2d2ba374d4bef8c4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9a9eb7abb1dc990ce993a6e1cf56255d572e11ad17dce53382c4d9ae3292554"
    sha256 cellar: :any_skip_relocation, sonoma:         "085dddc4d4d166c0fb5c9143c7f6028994d0965292e5b8bafe2da90edf4d91b5"
    sha256 cellar: :any_skip_relocation, ventura:        "b969fd0e158f813845b9b94143efc17eb206849281622678bdd945bb859e012d"
    sha256 cellar: :any_skip_relocation, monterey:       "39956620ee808bbcdd25b3adc0d8647a284d7b8100aa8ec8e3c473433885d224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "840a422323f9f372145822985a59a2295031a60c659888347c932b99f5ea4943"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    output = shell_output(bin/"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository at '.'", output
    end
  end
end
