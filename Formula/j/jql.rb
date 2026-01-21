class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v8.0.10.tar.gz"
  sha256 "f8c26ed8178de263ad06bbe6096de0e81dbf22f90a281d6fbd87d25c9f7e2dc7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84968f0bd4795164136f2812467afce9bf94fa885d84ed3a63e859d568f2dcf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3813b1af5cefd55ffd35a7ce51c95b71275d490038c45aebfd7ccb602a2f843"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53dd91c250fca472c4415143cb8db298673cdba335739a4304f75873371f6903"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac630a373ba506551dea9f991535546476344e6536ee2d9e48df75f78b5a9c79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f33adb947aa5c5868e1ccc1437f47a45e4a397b26ff164d9fbf56202a09d5c26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9df115cbf7add4f682b2ef2d54f2c65dcf5147570537795709f30299cfc5523"
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
