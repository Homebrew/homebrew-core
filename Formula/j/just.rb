class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.47.1.tar.gz"
  sha256 "2976e02f2dffd1ddc9cba57ef2fe75e8f4b97fde1657ee6fd145ab01efd789a7"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08f53380d74cdce3d099458537827bff9e295e510a5b7d8a402a207614a842e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a3ea2c290fd8b5ce9b999593b0ca92d7155e369bdf423ddc0423db4d0d09a1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f186a972d123c3802d4f0987375666289c7632b18286f6a549adbad983a3840c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e74bc1407ea90ccb7df4670a7626477f64a7b88fc62ed3819b6f552a9b08fa44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b715ad52225f53f57044a44f8f7c0097adf41ef7709385d44e59187394e1c642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ed95a60f2e2b88be42e054b77537c722c4c65a44565c1a3672b6d4b4eba26a9"
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
