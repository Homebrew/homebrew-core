class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v1.12.1.tar.gz"
  sha256 "63aaa1ec734e62d52331ee80706b24e9e3abc856a26d8e8289ce9228d38d87c8"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cd5ad3a25f80d2d2f42baa1b230180f8ff223eb782fd303834e41597427266c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7e44584e98abac0f1ee3724238308cc320de4d80ef8bc161727392c948a1b32"
    sha256 cellar: :any_skip_relocation, monterey:       "4e2928199d940bfc6d5ce94683df56caab8874ee026bef65ed794dabe224261e"
    sha256 cellar: :any_skip_relocation, big_sur:        "24765d6c4a62dbe0da38fadece43cd5370496187b1c0cc8f46c385155aad2d27"
    sha256 cellar: :any_skip_relocation, catalina:       "20c977cf5fd8c4770eed868e1143b2b4faa1897f94628fb325a535b62745912c"
    sha256 cellar: :any_skip_relocation, mojave:         "daabcc8391777571779235dd6bb86a04b8a8505ca64efd3c8c8c4aa455faa925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c9044a1ed9432cd4f370d60a726dbb0282d3f6c3d5014d4eae5d6d7d7ecef2c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s", "-o", bin/"dbmate", "."
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin/"dbmate", "create"
    assert_predicate testpath/"test.sqlite3", :exist?, "failed to create test.sqlite3"
  end
end
