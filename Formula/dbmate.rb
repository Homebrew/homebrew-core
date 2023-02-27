class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v2.0.0.tar.gz"
  sha256 "e3d05407ca865537f0467191999cf755aab3639c9fc8bd241332eb82eaf2d170"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33d74783e02c3cfd5f622a860c82b9f1978b0e8c62b8e50a40f94734e29fed96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06193eff6dbb1b1ba16dd4702e73733e705669dce19ab91c97ba578804734b2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a508ba543c252c6ca5e32dc50642a12a6d17dc586235c4ba2d792a67208f441"
    sha256 cellar: :any_skip_relocation, ventura:        "9faa92d12184c7379b09dc45214510f8df32f6bdc61b61f587c80d6c744f02bb"
    sha256 cellar: :any_skip_relocation, monterey:       "4aa4c47ffdf7837c6cded893880a9c4cdf1c743e3f6a6bcc4cfcc6cb5260e5cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "173154e4f74ccb8e3101242edc0600958cce4ab787f5bd19d82711ad024c74ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "099604b3eb89224ccc2ec8092835016e15b5862ed9b2c3cc78eee9a440c5e298"
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
