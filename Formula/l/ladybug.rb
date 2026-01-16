class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "9fcae7c52640ea11dd58c1424552dcd34bdb835e10b1c812fdd361a7a1b30377"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85118d8cbe0dd171baf10824103f938fd139bd971fdf74864c63a7ef92e43d6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "241757fc482e3679056b74e344a3c0c58d9050df013bdba3457f8418db5726a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e1764e7e275ddd54c4b3caacc1ecfdd2b0977adfbff989fb78832b33c428e36"
    sha256 cellar: :any_skip_relocation, sonoma:        "136df9ec9fb7b9d0f7973b617372cb1d5b5e994461156f9a2280ac96540d1933"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b897b41a46b517b2c1fc857a7f67fcd016f2de8decbb7f10ac0bf6fa6cf576c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c090dfae861eafd229be01fa76d6b47562ce97bae6fa4d9cf51f5e7422f57ea"
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
