class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v8.0.5.tar.gz"
  sha256 "8a4441d7ef400967fc953a09e6becba4f60736993e8536082bcb4019a0475074"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dc2dd0ba728cbf11aecd3a828e21fe896b09b780d39a6337d4b56dd834d6ef4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83839702d270572ed734e6813937bc80a514e1d3a0d00624c6734ccb653066f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0b3068e2f4ce83b9f019defa18517dd7c4087ea34b4aef446979e43d0afc91f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c007330f3f906b8d17fe167ea99d760033a1305edaf0d91310da5f13d2d7c28"
    sha256 cellar: :any_skip_relocation, ventura:       "089e28590e00f5ff0a4c5b8d9d36cb32564a7c4908c3dda62b725958f939de19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "470220cbd9f205b1cb9049e20a668b1db82636984adbdc9489c1990e5f271859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a36951d560ad0dbf768433d07e1cec3f30376170bccfb62b0d024999aaf7fc7"
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
