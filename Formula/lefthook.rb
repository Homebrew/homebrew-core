class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "6a14d0354ba635c8fc188c351e59dbc057d61de3dc6a8d6a17fb4cecde260114"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cbed72a1ff745afa5c9ce58bd32b443c89d1b7495073846a54dd97819c18d82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdf425065f1492298537520975b3edc9d48f698a694054cd398627f855749eb0"
    sha256 cellar: :any_skip_relocation, monterey:       "c4c62e6b42642ebd1e9a1bbeb67f306907fda7be8a14a42bd1048ff701e6441e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e9f898e2e7600402a1112962429c283981f19b8325356ecd858fe318add8660"
    sha256 cellar: :any_skip_relocation, catalina:       "8d142d956cc277d56a9132d53679f171d9081abfd71b0b10070188fc653b38b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f0f9d0f5267faee32672bc0a84198066a0b5078271e8941cab837c08f695b7c"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
