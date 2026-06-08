class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.51.0.tar.gz"
  sha256 "ed424dcf55ec08e22a0c58f6cfb7333573775d69dac3802bf0c1d96f7557089d"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2c871c8572165e3e9141718deb9609a489281c892bfd2dd742e38163133e8c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ba346552d26b9f8664d566a008d8fd3a010f769960ec4e56c345c7449b49178"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3c65b48a751dab08851c9d69aaedaa03ae33c4d5df2659b704a003a8412a32a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc725ad84b369b44d52b08a6ccdd69409294d8d84b8d55ba7baf785a770d2130"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61f19815c733a42362cd705643d412b08da7b0a290a8a5ddc61e13c71915fe11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcae6fd5868fac09a22b013d68d0f1b29566a02700005185a7a4f1dbfe990926"
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
