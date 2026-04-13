class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.49.0.tar.gz"
  sha256 "442406ee14eb9a59414525cf262354fe2e752b22c224ce2a5e42b2c493226e09"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b28e47a20eae87978a81a37814d475eeea6b19ac6422e6c4ed7077be9c0477dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b4278eefd78e2e445e43c027a443a445d32bfc10e8439f6e50892adec30506f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce7f39e7b57542e65832cc089382b7f1ede3266ba77040647c62befd0e692eda"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a5429af62782e33c1c4db2c9452b555429dcab2989704e344d9b7859e29531e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b715f80aaca6797e6d6377f2dfa5aec3657b0bf30b67fa0752431fd91f727a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c94a3076defeb3ab337bb78e6442a3418ee54c5b07a9e4b8e4d83d15ea043b2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"just", "--completions")
    (man1/"just.1").write Utils.safe_popen_read(bin/"just", "--man")
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_path_exists testpath/"it-worked"

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end
