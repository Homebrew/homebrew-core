class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v2.0.1.tar.gz"
  sha256 "c670fd76206d07f77f5c4ccf17a39c94d39f0df55e56247520ed2b799983aa9c"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3169981a2fd0e46620022f2f354e37eefa8dae29774298d3a66ba1d4d49e4c0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "711517cf6be5331e3e121277420fc10171829c3f230a60b6a1128c90cc3425d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38c4f9b9a948738ba92c0d6c776c38af2f1bd0fc360eb8f407272d541873549d"
    sha256 cellar: :any_skip_relocation, ventura:        "bfd3fbd5055533a8650a1ca9dc7cef0854637ec49120e626961fb29dae519d4c"
    sha256 cellar: :any_skip_relocation, monterey:       "42e833a0b840bf724712952efd3b705d4f277b5442dd683aa015661ffcf6b9cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "861b7b2f4de10462cef163f6dd94ec708af1371f0d8e7674def28f52cebe1bad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56cb9995292dccbcec8d8d1087408372c68214658e352433bfcccb5d3e4f2aac"
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
