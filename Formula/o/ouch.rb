class Ouch < Formula
  desc "Painless compression and decompression for your terminal"
  homepage "https://github.com/ouch-org/ouch"
  url "https://github.com/ouch-org/ouch/archive/refs/tags/0.6.1.tar.gz"
  sha256 "e6265071affab228ba7d3ca85f2206029445038b3a3d96036e9bf02b795ad651"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1763a70081770f67d8246c019594ca196c8829585178b93d486ac9f92865e1c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfb7387471264b6089243b31d22b40ba75ac370c64c1835d06585df5c2dbfafe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "326375a6f882717b1026228a031e840133b9944115be3251edd7897c6ec00378"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66f692a605fdbfb28109a8a83e3c51539910783fc33310802c79d5b97f7ce57c"
    sha256 cellar: :any_skip_relocation, sonoma:        "89a565161184ecfedd0860b555615c0d01b6dc8495e1ddb99d90c2c274d96602"
    sha256 cellar: :any_skip_relocation, ventura:       "54dc9ec1164b7058dceabeb8db74993f87110a967fe3fa969b98f37339608837"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b114aa892caae3291d102fd04c811b4b60091a3a1ede4cc36fddcf16bc421866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d0d0e3fe53abf7a1a280cf73786d1125de2800927f8a01d90d5658f02b581a6"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "llvm" => :build
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
