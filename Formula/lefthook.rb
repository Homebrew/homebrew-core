class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "d8238c3fcdecbbf580039170fa526606ef90554999f1633a2e3947d144184a13"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9496358efc54d1bd0e772167c6b4d0467b2a2850471341b7506061aab409d8fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "088e317d3557fa64e5c64f4b9643b21cab96c99270e235b722f9c65fc07c5c4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fdfd883237e982f65cdc2b708f157e6beb0783b7077a79206e3c969a46b37be"
    sha256 cellar: :any_skip_relocation, ventura:        "c94b0b7c4e4194c646cd2355f563b9e89bc7d968084ccf6d969a9f4c72f40818"
    sha256 cellar: :any_skip_relocation, monterey:       "77946c64f5d8000fbe4d4879038d5e1fcea1b19cff28366def20f29d21350397"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f08b4b5a4d8369183649d7f7fa5e4bca1567e13950f565835f7b382bd604c9b"
    sha256 cellar: :any_skip_relocation, catalina:       "1a63dccc0a938ee2f058c3f89118f5825ab7010eb8ab8ef3c297258ccffbb1ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fdd626aa2f4da2533382d22534e0dd6019ec3e928913cfc958403b0ec0eca49"
  end

  depends_on "go" => :build

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
