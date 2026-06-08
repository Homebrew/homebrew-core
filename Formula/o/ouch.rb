class Ouch < Formula
  desc "Painless compression and decompression for your terminal"
  homepage "https://github.com/ouch-org/ouch"
  url "https://github.com/ouch-org/ouch/archive/refs/tags/0.8.0.tar.gz"
  sha256 "72ed23c0b2aa51b1b33d3251ddae14cf2bb07a24035d1593c06fc97070e4edf0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e40adc94ff6f2c943bbc093e966bee940274302d608916a9886fd9c4f5df2b3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3b14f2d0b83e473d0fef0fdee81b9613d13664c518b7fa222fb847c80dd3585"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb4ee8d96140fb17d18dc5fd8e323ee8399aae510864f178939f31efae36daec"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b085807ed0527dff9fbe60cf70df7b3b1ef4f14cd5ae5894d0678eeedb35055"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b17ecea1efc97062523a7496de51c262b4b20a0d931d739e95e81130442b140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4ba15ecb9054c3c76a85aabe7c3a4e94c19669e79803e41db9938b51f9ac6ba"
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
