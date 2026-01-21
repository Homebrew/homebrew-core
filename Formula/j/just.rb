class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.46.0.tar.gz"
  sha256 "f60a578502d0b29eaa2a72c5b0d91390b2064dfd8d1a1291c3b2525d587fd395"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "768c90154511401701c95fe7d164b32d8c4034eab968b63102fe45127e5f4c48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0820cd672672ad32cae4a30664d9018393d7472ccf0293bf15bf291b3a87e15b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b966c3dc75926ac52fc27425f009beced200de72b7d00b50787ffba4448ece75"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca37ef9c9687418ba488b8c4070cf4682dc83c70504919361bf9cc60b7b645ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1c1cc78b5b7120a63ce6172f11f7fd3bec2b493143cdc25fe22e1dbc433f5e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7648640674f926617ba404a8a3097665aef0e531c3d2b9d8b56d55554ac2b9c6"
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
