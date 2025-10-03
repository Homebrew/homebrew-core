class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.28.0.tar.gz"
  sha256 "129cb7f978e4316d6d02d2038eb346a94e1f988bcfb30a83aa99c6685c71d359"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94d782af69a13dbcc25556ac48a5d2ea24f39bc8f97a2597ac5e47adef8f962f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c3fd4526ae0a3f19647d02d26344a6e0d51eedc58072ddf28362d1cb0799fc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b8c469c5164e9778c6fcae14ac12da99375b8164cd76131d2e44ceabc69ae74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25879f4d7bc0b90053f582e98665facca06e8bb5230326ba1c8c91be83660409"
    sha256 cellar: :any_skip_relocation, sonoma:        "17a7a0033fdf4715bd0f7dcec07f8615c8e96ec1e5adeb31715c1966ccd35100"
    sha256 cellar: :any_skip_relocation, ventura:       "9a183cc4e1a8a57584a405b83de7176fb2f4223ff49764f0b058fa54a8b49fd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef7b2a9b29cee7d6155613d801c09ab0842f610bbc845b35dc06f32a27197c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ae1180123b5339d27719e6d0700f05830f4e3fd29c001bdedca1ff2e107f14f"
  end

  depends_on "go" => :build

  def install
    tags = %w[
      sqlite_omit_load_extension sqlite_json sqlite_fts5
    ]
    system "go", "build", *std_go_args(ldflags: "-s -w", tags:)
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin/"dbmate", "create"
    assert_path_exists testpath/"test.sqlite3", "failed to create test.sqlite3"
  end
end
