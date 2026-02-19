class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/refs/tags/5.1.0.tar.gz"
  sha256 "5ef8864dacb5b37268d7d26cd01f74b99a33b2e5eb5b290e4221358410c99db4"
  license "MIT"
  head "https://github.com/cheat/cheat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77143bff0b89d1b3cb6c881294a35500e9a6dc9dd735d7f38ad15542f91a49a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77143bff0b89d1b3cb6c881294a35500e9a6dc9dd735d7f38ad15542f91a49a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77143bff0b89d1b3cb6c881294a35500e9a6dc9dd735d7f38ad15542f91a49a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fe124e0d74005a57908f8753bdd402510bcbe1215e15b30020793ea86287bc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b75f7b7e610b58eae3599f2db4570aa3e10a7ac54c71e4e203ff599b3583e006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53c661bccbc4bf58a94f831b4d0c766254fe83eb1fd86b2030b47b33a4a81155"
  end

  depends_on "go" => :build

  conflicts_with "bash-snippets", because: "both install a `cheat` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cheat"

    generate_completions_from_executable(bin/"cheat", "--completion", shells: [:bash, :zsh, :fish, :pwsh])

    man1.install "doc/cheat.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "cheatpaths:", output
  end
end
