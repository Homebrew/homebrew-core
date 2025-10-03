class Gql < Formula
  desc "Git Query language is a SQL like language to perform queries on .git files"
  homepage "https://amrdeveloper.github.io/GQL/"
  url "https://github.com/AmrDeveloper/GQL/archive/refs/tags/0.40.0.tar.gz"
  sha256 "e5ee71afc946922358cc73fcba95a06001864394b7c25341a7114b81fa2f36f7"
  license "MIT"
  head "https://github.com/AmrDeveloper/GQL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02105fd62775c1a82f9ab521bd1d9edaf75d2d25a08ab6c5da4cd24f7f51ebbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d067ebe79fd1387813fe23b7a4d5f4fc2145a1a41f662f641de5d15473b2a6eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d7a765553fc6bfe16096f158b150ae2ddb1d708f22c5c5d3bd84fab41338d1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99918c99fbbef93e4f851c0f4ca18b959b5c7fa43e71e04672b52d33b39bf398"
    sha256 cellar: :any_skip_relocation, sonoma:        "2050538ffebfd69593746c6b4096d32afbacc0b5d7d5ca613119efa49f9c2708"
    sha256 cellar: :any_skip_relocation, ventura:       "2f846e30b3041b728f78e2c99f51b1734c418c99f0477b6bab21e888d2adfd13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e35b813cc7235b1189f17de6cc280ad7da9e7b1c6ba8aa2dee609519d362c5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ac640543049c3d594b5724e0d8bbbfde52960790187a5952f04511e27f4df64"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  conflicts_with "gitql", because: "both install `gitql` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    output = JSON.parse(shell_output("#{bin}/gitql -o json -q 'SELECT 1 + 1 LIMIT 1'"))
    assert_equal "2", output.first["column_0"]
  end
end
