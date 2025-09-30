class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v8.0.8.tar.gz"
  sha256 "acb621bbfc26e44c2a0518e56a57ba67e8faee79c31f744e13cdc5f529a213b8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c6c5ba6d51cb9ba0522225c3ca84161fbce99762cb3587585d7f57bc03112e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a08229c8b596c3554d9916bd6907af6a41a07a9b2b062328dc9af3ec5c8aa911"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bf555ce87bc59bbd2eea7868eb54faab4d512a462bcc8b51135c946bfc0b0c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66656e5a644ee03c406efdcfdecad003c5e41a8c59eb77775efa80fa902e23fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "efbae08b82c36729751aa00d6569d9dc59b03f111de83705609177f2f5ddd202"
    sha256 cellar: :any_skip_relocation, ventura:       "7b2b01f7ac76637452c887f64758760e0878b4e909dad1c1e052e0ec7aa25772"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50179a63a7989bf5a1c410d181e6746dbc4254c4d86fbdd63ef6f4222e7b5e2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2af6b8384bd5318d4e2cd137e91bab997c84e2913cd6a63ed82720ad58341c68"
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
