class Gitql < Formula
  desc "Git query language"
  homepage "https://github.com/filhodanuvem/gitql"
  url "https://github.com/filhodanuvem/gitql/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "e3d34649f3dc714cb3189638103918314cf63b1ddbfd99a067d802730d1119b2"
  license "MIT"
  head "https://github.com/filhodanuvem/gitql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d618f75c432dbdc17d9bcfeeec547b258b34a1146de33c9f1da2d7c771992e59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b9a80a375a5dd73ffcfbba747167f029ea4c3c97d631d9f4a8c75e83f415fef1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "331949f049d7c58c277f5842a3dda54101c55499a070c22f1481f288d573fcfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3aa2f078b36976dfbfe3b5a906ac43f625b04851fa400e03e21d5abcc965c9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8d5a45420e0c8696a821493c292c57a929d5571007fa0d6863a6c0479c17e0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c510bf179af95811b10550f58751e33b54f7becae1106ead14d2088058deb141"
    sha256 cellar: :any_skip_relocation, sonoma:         "49095a2c9239aa2d8f4948e6b48c3cc2bf25e2cca551092517b6c09293d558b4"
    sha256 cellar: :any_skip_relocation, ventura:        "1afa4269aa54b3f990d4061b7fe21424c9aeb509ba86a6af4a6b7cdfd5d6daf6"
    sha256 cellar: :any_skip_relocation, monterey:       "211d0bb817e59169943c5e12a9b6b147cb74a409eb59af501e774eedf30d7f4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d03ac14a4d11bd7f0c09694b68b04b679eb6fc1feb5b292b1c289417e46ce26"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d0357e2209734c9b1f78e67b4826b529eb010d787eea301987609e60eecbc729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39d4bb77007f584d4ebfb5f3b6e1d40e1c6794fb728f7e32877b75d6ca3f17cd"
  end

  depends_on "go" => :build

  conflicts_with "gql", because: "both install `gitql` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "A U Thor"
    system "git", "config", "user.email", "author@example.com"
    (testpath/"README").write "test"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match "Initial commit", shell_output("#{bin}/gitql 'SELECT * FROM commits'")
  end
end
