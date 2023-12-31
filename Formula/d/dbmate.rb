class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "c7f53a29d2ccfdf19eaec242b0bce0293e049f6d5d36a22b8393c6a491dd406d"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88048c66e9ab32e332a5df94360cd4da28e124ffc02bdca537438aab252f9cd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b55e008916b3b2c1c4964938c20e0ad75362534d8edd69e643a9e17e3c7225b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "047bd41c13041ff6624ce3c37a2aae6f8cdcea9907c7735d4fec4909297d3b0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e0280058f06409cf2dd23c1a353783f0a829dfee313f96aab7c8bdf3f8c4e8f"
    sha256 cellar: :any_skip_relocation, ventura:        "b58e90c59072cab4a3a342a6e64aa81fd4557d09ca6196601b312b4d69784b59"
    sha256 cellar: :any_skip_relocation, monterey:       "1e377e62a1c8e26ffa64c9e04fd705e1d646435feafa0d948c10abc2c030c333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ec926746583c23cab866a43b2f5db13d35022636f0c50a20fd1e55937c70b2c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "sqlite_omit_load_extension,sqlite_json"
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin/"dbmate", "create"
    assert_predicate testpath/"test.sqlite3", :exist?, "failed to create test.sqlite3"
  end
end
