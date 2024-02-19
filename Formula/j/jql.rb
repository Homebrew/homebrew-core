class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v7.1.5.tar.gz"
  sha256 "f2bed4e7f9e7bf0f85c6f9918c9d38805f76f6ae131442ab95a3b5ef5a2bf6d8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d320deb1830fee4227b5b381f4ee98572e501b1e11b18e04d3f9d9261520607"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5f83553ee0f6b0da099b4a393575be029669de570be5e32dca1fcc690edd86d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65a8e25f67fd759b3a6c52bae3c329584b85a65a84717f4e81a354e3696a0b88"
    sha256 cellar: :any_skip_relocation, sonoma:         "8dbbe31507cfe3586eaf77bd29e04aa827e0cf44311fe556160192b61b7455bb"
    sha256 cellar: :any_skip_relocation, ventura:        "954f31b92f38f0a8588acd9b9dc3e5f4a43bf5f01be32a0e5325c7d0ed891c1f"
    sha256 cellar: :any_skip_relocation, monterey:       "9f0ce1d7e9bd235da66d780af1a59f976659270831dfa17b30e86b25b838c6c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4c2f228614757c89de982f7c6d198b650db7a9a0caf488e201530bd97583282"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/jql")
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}/jql --inline --raw-string '\"cats\" [2:1] [0]' example.json")
    assert_equal '{"third":"Misty"}', output.chomp
  end
end
