class Graphqxl < Formula
  desc "Language for creating big and scalable GraphQL server-side schemas"
  homepage "https://gabotechs.github.io/graphqxl"
  url "https://github.com/gabotechs/graphqxl/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "46c9331f12ffd9fb0d5d9d00116315adbf0f53b8eb6aa6db6d675ee861bd65c4"
  license "MIT"
  head "https://github.com/gabotechs/graphqxl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f032e6335417a0095a2f554d811c8c089b3ac65badd518dcb1d22b40ca28775b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9a71aa0bd56882621eb24f5ccff6dd8034329e34a71cd52b4d56b65bbb4a268"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7452c9d8e43dfb5d4a74ba1b0dc7d7a409b6a8d4493668b8f07ae5e01ef599ca"
    sha256 cellar: :any_skip_relocation, ventura:        "07d6aa6dc0e58bc0822f994cd79e75e45e8f969f14af28534697ccafcd7bbc34"
    sha256 cellar: :any_skip_relocation, monterey:       "f84714cec431e0cf0dc317fe2bbbe5f4bf232b2fc9c9476bf403729fefabb12e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6d0f904cf302e4b752f470368e6c1d909746a770396f9ad009880f001c0a37b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "662474fd9fdaec4d3ba8635fbdee1997c6103c0b3f56356eda11e5d94ad0f6fe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_file = testpath/"test.graphqxl"
    test_file.write "type MyType { foo: String! }"
    system bin/"graphqxl", test_file
    assert_equal "type MyType {\n  foo: String!\n}\n\n\n", (testpath/"test.graphql").read
  end
end
