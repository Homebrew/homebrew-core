class Graphqxl < Formula
  desc "Language for creating big and scalable GraphQL server-side schemas"
  homepage "https://gabotechs.github.io/graphqxl"
  url "https://github.com/gabotechs/graphqxl/archive/refs/tags/v0.40.2.tar.gz"
  sha256 "2ddc205e3943e97273984e64bdac3d41c70b87eb408976d7d2108163fca35d4e"
  license "MIT"
  head "https://github.com/gabotechs/graphqxl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1fa9241adcd928c8c8c584f1c12769d24dd91f3657926aea93b0003794f5503c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "18eac4ebc83fcdae08fbc9fb551a1bcb8482c335a6fb8e8dcbbf4094b2d68a54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db650e0cf356bd6d3110efdee992a5fa0274aefe1c1234f3346088892f5fb4ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da797791cfabeead0366235dac708006bfedb1484dee814bc50099c8fbb63b74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaa39d46d3686e1333450664b027cbc6c3647da3500f7dcd579562cb7be434fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f6672a7d830d21d5a8650857ec9abf5cf28085547afc9bc5fccb7beed939840"
    sha256 cellar: :any_skip_relocation, ventura:        "b891e5456d2bc434589d9f8e3bfc6f30c6b94792a546e8bdbbc54f1930b57702"
    sha256 cellar: :any_skip_relocation, monterey:       "b373aa6635fb39ab61ba72892128510c76e797ac2bac64021aa2830b9d36c070"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "82c0cab717aa8eae1f5e4296dc00f7b9a79dce7a624f92f1f08b9b271b4ad855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0590778c7bf3f82a06c692f8dd55b47a24f97aff7ed5fa23e37d61dc8f074492"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_file = testpath/"test.graphqxl"
    test_file.write "type MyType { foo: String! }"
    system bin/"graphqxl", test_file
    assert_equal "type MyType {\n  foo: String!\n}\n\n", (testpath/"test.graphql").read
  end
end
