class Ouch < Formula
  desc "Painless compression and decompression for your terminal"
  homepage "https://github.com/ouch-org/ouch"
  url "https://github.com/ouch-org/ouch/archive/refs/tags/0.7.1.tar.gz"
  sha256 "9dadaa3340972347c39e0047668af0e2c59c6128470eeb3fdf86629a3b298443"
  license "MIT"
  head "https://github.com/ouch-org/ouch.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68d5e3db708b3fd385c3f9d1d575a257137a572029a2b6d82a4e1183bf9467bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07e34cb0c0f1599b68ed3a01ea1d221df8d7e7b19713ca958fa327ef405621c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8258bc3be36636ac68271cfebff7c8fd649fbc46f6cd5879e24f92878d6ecf33"
    sha256 cellar: :any_skip_relocation, sonoma:        "eca7d6f6fc2e25b5fcae2543379a25c2a55f45e044830c3361dd5e5f7ecf9d76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39da262a28fcfc07292410df88c7aec5fa2f1fc4e220049b6ef45d4e2e63aa67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9db4fb1ec7dd3d59b356c815149004553ca1f6b588c45072f3fb36016b3fbe28"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # for completion and manpage generation
    ENV["OUCH_ARTIFACTS_FOLDER"] = buildpath

    system "cargo", "install", *std_cargo_args

    bash_completion.install "ouch.bash" => "ouch"
    fish_completion.install "ouch.fish"
    zsh_completion.install "_ouch"

    man1.install Dir["*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ouch --version")

    (testpath/"file1").write "Hello"
    (testpath/"file2").write "World!"

    %w[tar zip 7z tar.bz2 tar.bz3 tar.lz4 tar.gz tar.xz tar.zst tar.sz tar.br].each do |format|
      system bin/"ouch", "compress", "file1", "file2", "archive.#{format}"
      assert_path_exists testpath/"archive.#{format}"

      system bin/"ouch", "decompress", "-y", "archive.#{format}", "--dir", testpath/format
      assert_equal "Hello", (testpath/format/"file1").read
      assert_equal "World!", (testpath/format/"file2").read
    end
  end
end
