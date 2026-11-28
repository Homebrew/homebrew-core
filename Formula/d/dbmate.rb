class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.38.2.tar.gz"
  sha256 "e213692fd2c45790018966d118ccdb27040effc764058437a3006d2b1c9dff74"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    manifest_sha256 "a1416e1a5dd23f8918a4b21423c3dbeb4fef12efedf015ee92fe00f22c2a5574"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3266ed386b989e63bb626f848e160e1772eb94c91bc745536f6bd7cfa924959f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "382c7eb20acdc6a8ce8414e93f49964300c69c00bcf280234ddd566a8698cc26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "625834a795d9528567a2e863f9bbd75052315023f26da45a136a623cce91fc7d"
    sha256 cellar: :any,                 arm64_linux:       "f964fbfc8ef6d6c33f34302b9a794a6345e87bc555b39a01b1fc9c2a062a19e6"
    sha256 cellar: :any,                 x86_64_linux:      "e23caa7a5ca6776c711cec71cf04f0eae139cac4f6ce2102d7ce0aef0c380c5a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    tags = %w[
      sqlite_omit_load_extension sqlite_json sqlite_fts5
    ]
    system "go", "build", *std_go_args(tags:)
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin/"dbmate", "create"
    assert_path_exists testpath/"test.sqlite3", "failed to create test.sqlite3"
  end
end
