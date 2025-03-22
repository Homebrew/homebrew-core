class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v8.0.4.tar.gz"
  sha256 "8df953ecf3ba468b9c9794252cfade9e33b58e88f4079b152ba4d0f4a13438e9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6228645add7ed42576b751ee4c200658c7d19ec2b631497743ef0ed5c34ea1bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e009ebde46adcd02c76602f8f71339e5d4e7b2c7a284198ef49cae7654d9be24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43e964810dc101e795e867628d86ad25404c15416a6ba90637dda6179401143f"
    sha256 cellar: :any_skip_relocation, sonoma:        "535d6bb3802d13821fe8be34ac3ac58ae8ba68d4b414227d467cc873db1086f9"
    sha256 cellar: :any_skip_relocation, ventura:       "06408e47393138a24a5b2e775903bf1785e1759445d7a9616a3a53bc5343f386"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee5160796f83b90b02bb5d1e821b2a33e8c98f4f687cdecab28377a067921b41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "981b4266ef8f57a92d74113d452b8464c7fc0c480c29d33e94d1f8e9b7e7c103"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/jql")
  end

  test do
    (testpath/"example.json").write <<~JSON
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    JSON
    output = shell_output("#{bin}/jql --inline --raw-string '\"cats\" [2:1] [0]' example.json")
    assert_equal '{"third":"Misty"}', output.chomp
  end
end
