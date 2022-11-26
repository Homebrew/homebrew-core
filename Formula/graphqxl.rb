class Graphqxl < Formula
  desc "Language for creating big and scalable GraphQL server-side schemas"
  homepage "https://gabotechs.github.io/graphqxl"
  url "https://github.com/gabotechs/graphqxl/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "10093f0050f1034a147d06313aafef1e9efcfd158d157cfc27aa79d12e5b3291"
  license "MIT"
  head "https://github.com/gabotechs/graphqxl.git", branch: "main"

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
