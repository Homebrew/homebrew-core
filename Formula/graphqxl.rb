class Graphqxl < Formula
  desc "Language for creating big and scalable GraphQL server-side schemas"
  homepage "https://gabotechs.github.io/graphqxl"
  url "https://github.com/gabotechs/graphqxl/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "10093f0050f1034a147d06313aafef1e9efcfd158d157cfc27aa79d12e5b3291"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    File.write("test.graphqxl", "type MyType { foo: String! }")
    shell_output("#{bin}/graphqxl test.graphqxl")
    output = File.read("test.graphql")
    assert_equal output, "type MyType {\n  foo: String!\n}\n\n\n"
  end
end
