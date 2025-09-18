class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.42.4.tar.gz"
  sha256 "bd604ff72ecd8d8def79d39997499433e22fbffa03260e3a2c5fe5f84cc37f52"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c22ceb52b95484b6490b4b5225b3e2d7fd0cad30f4844f38d080106fd606b95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57076d07f5f1fc05eee9b042ba12cfb4dd233ec16c97d970b88451fa7f5106e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9eef325c85d84d88826a945f52aaf9418d115164f80e8e17c740ed65c3a050c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7020ff9b8e115ed3c8b48e26e860278ecf8c5a18ea3c9901aae71d8aa58b572f"
    sha256 cellar: :any_skip_relocation, sonoma:        "01939f95ea12bbc1d9ec8f5f3db07ff39fe1dd471d992aecc1e833e6722f55c2"
    sha256 cellar: :any_skip_relocation, ventura:       "a1f3fa3f7b33f8e861bad7bf4cf3c111e5822f5c584b52217c9431d6d74b6ac2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4733813da740f913bcaa6b5c8cb5e0acb828c28222a65f59dcbfd8b8a29ca6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f55c310dc5d7ac4fde2c30bfe29dd11b2cd24200b0f3453023a1a98c7d61677"
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
