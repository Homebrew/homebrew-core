class Dipc < Formula
  desc "Convert your favorite images/wallpapers with your favorite color palettes/themes"
  homepage "https://github.com/doprz/dipc"
  url "https://github.com/doprz/dipc/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "dd98bf2eea8e97dfaeb8d4e0a991a732e35bf71e1b9bdf0045fdad80e0c0d319"
  license any_of: ["MIT", "Apache-2.0"]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6cfce35595b22d154392487111416ee930389f21d5b83875bbde40fd2ff927a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "182b6056ad68e867829727c6112022f45c207fe32312193a5ed3c7c69c4a1a6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e38cd4ab7323ef745a39bb70fd7bb62ff158aaefa17ad9195ece908f6de633c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de128a4b41bfbed37c27968b07a8561d280a0f389d5a6a3326df09d7bb1e120c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9a718e1a4ba5745ad5c43d5122c0b73c11c34b02f395f7a0126cd5d591a260d"
    sha256 cellar: :any_skip_relocation, ventura:       "307edf5ce6bbe7000e6e17d26e771558b9a7b6d330f0111cd2ce9b1ea2d09f81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9d4c00739e898767683f201b27d5b753bbb374daf96909b02dddf7027e5a0f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13a6a7cd17b79209983f4c8a09bfd44218117d35f86e159c5f847fefae4eb0be"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test processing with a built-in theme (gruvbox)
    output_path = testpath/"output.png"
    system bin/"dipc", "gruvbox", "--styles", "Dark mode", "-o", output_path, test_fixtures("test.png")

    assert_path_exists output_path
    assert_operator output_path.size, :>, 0

    assert_match version.to_s, shell_output("#{bin}/dipc --version")
  end
end
