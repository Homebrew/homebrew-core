class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://just.systems"
  url "https://github.com/casey/just/archive/refs/tags/1.57.0.tar.gz"
  sha256 "905c556aad3c0a4b0376db98b706a9aa3485fcf50a30377d50737bf20f3792cb"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d35f56e699d14cc14a8cedeae952d6e9e5798606a8b8e8f2ef5e337e8ea632af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dcefaef320a4f7c849351be6438240201686bcc8fe0987cc5d9decb779bdb2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "960527acd994d86598564a40b4f6c1c97245037157d5f7e70a70f3a07362e4d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "185565b50deec82745adf9dac3f5ea42c8933f129e5e2d6335be521e13782445"
    sha256 cellar: :any,                 arm64_linux:   "c6c07d3f946142800bc78753fd81b09d97da26470ee03622f2db020c8c83941a"
    sha256 cellar: :any,                 x86_64_linux:  "f799a5ebf5e46580e88d4ab527b210fd872ecfd7f237839b7a94500384ec706c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"just", "--completions")
    (man1/"just.1").write Utils.safe_popen_read(bin/"just", "--man")
  end

  test do
    (testpath/"justfile").write <<~MAKE
      default:
        touch it-worked
    MAKE
    system bin/"just"
    assert_path_exists testpath/"it-worked"

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end
