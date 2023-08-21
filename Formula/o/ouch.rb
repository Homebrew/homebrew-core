class Ouch < Formula
  desc "Painless compression and decompression for your terminal"
  homepage "https://github.com/ouch-org/ouch"
  url "https://github.com/ouch-org/ouch/archive/refs/tags/0.4.2.tar.gz"
  sha256 "08015fa92770515cfa00570bc5f0f0a4f28f0ad238f360f3579ac043723a6ec2"
  license "MIT"
  head "https://github.com/ouch-org/ouch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec1b049ea8832d42f39f83a2d0ef2185ae737c7433e3acf9340007f18b79f862"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db9109dee0173bb7e3eaf4e3e86f4315ec25e1797aa6572f3dccfbbf28f1c546"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69f5b83f2cd0d737a7d7af53d1fe72a6b546ae176993a303b797099247413ed8"
    sha256 cellar: :any_skip_relocation, ventura:        "28ef4e935f84559c0d05c5772700cc080e2cfce28ad422212035c6eb7c0ed089"
    sha256 cellar: :any_skip_relocation, monterey:       "adf91e57dd711519450add15d3354f9950b0be6537b2c6e3793b3842cd09a17f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c74ec00b620845ee8f940c5345a45975d13ea24f8b410d34a5964370fc5180f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39c5252120495cb5020b2ff5e89a26faf3e7e77f68447b59bfd38a50a120f4ba"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"file1").write "Hello"
    (testpath/"file2").write "World!"

    %w[tar zip tar.bz2 tar.gz tar.xz tar.zst].each do |format|
      system bin/"ouch", "compress", "file1", "file2", "archive.#{format}"
      assert_predicate testpath/"archive.#{format}", :exist?

      system bin/"ouch", "decompress", "-y", "archive.#{format}", "--dir", testpath/format
      assert_equal "Hello", (testpath/format/"archive/file1").read
      assert_equal "World!", (testpath/format/"archive/file2").read
    end
  end
end
