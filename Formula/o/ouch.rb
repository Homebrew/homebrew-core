class Ouch < Formula
  desc "Painless compression and decompression for your terminal"
  homepage "https://github.com/ouch-org/ouch"
  url "https://github.com/ouch-org/ouch/archive/refs/tags/0.8.3.tar.gz"
  sha256 "f695393cbbd89cf5a2095c32235e585a85432ccfb902c78d2a2e9787abbb439c"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a70f65653c18fa8468a5031b4e33d07da96db972b95fc7f811a7654dfb1ad8ec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d348d3a35b9387a354d32ef0055cf9f0486472827d77249a78f326c3811c083e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "98d77ead4acd9daa3e8f68470d6d31d92926e0847396de926e0b7d61a98800ee"
    sha256 cellar: :any,                 arm64_linux:       "d512ed800733b5fa9bba0ebbc4c2f9a76247242ef716899c93880d3b3ffd65ae"
    sha256 cellar: :any,                 x86_64_linux:      "54743318b86798d93e41c0971807cb3378aa96c87bf2b897e5a418954f96c1d4"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access! :test

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
