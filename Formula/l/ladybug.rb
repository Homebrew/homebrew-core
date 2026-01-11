class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "0761519f843178e79e7459bd8c61e18af8660586faec8cd08c7f0b7dba19267c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ee668faad7fd7fee4660b765282429507dc169603b2896564830e9dc7169ac5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13b1008fea84cdc5b16a73cb9d083187e2731ed858784f25a766e8a525331613"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c584b28c4581454977e15e2e0e76640063dc24962c05322d53f87ee281be29f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d103041f736015e654e04e7fcad29dbf3c5ca31d575d47cff2a093ba0b92460"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0ea598575a318a0c846553bd24214841ee691cee482df222093673480ad18bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c209a655855f26a0c040f38472cd0275bd5ec768593ba03116d8277f4233096"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/tools/shell/lbug"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lbug --version")

    # Test basic query functionality
    output = pipe_output("#{bin}/lbug -m csv -s", "UNWIND [1, 2, 3, 4, 5] as i return i;")
    assert_match "i", output
    assert_match "1", output
    assert_match "2", output
    assert_match "3", output
    assert_match "4", output
    assert_match "5", output
  end
end
