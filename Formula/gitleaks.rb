class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.14.0.tar.gz"
  sha256 "0dd51bf638457c7c9a734db11e78b01afcf7d0d45db1716a597bf9e9f048fcf5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3670bb0ec762c601bb34a81a8522c124b06620487918b486562f3d481e15d6eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d49343f107daf9551a71faa1e9a522f1458c95c09c4aa2bf7297d328528415c"
    sha256 cellar: :any_skip_relocation, monterey:       "65b36ea91af44ccb6876c4ceb06395a5bca57562ff43e39b6284006f12771fc1"
    sha256 cellar: :any_skip_relocation, big_sur:        "d330a7f23d15cf86f8ede516516ef83862cf63fe6e74f938c89996d221785cbf"
    sha256 cellar: :any_skip_relocation, catalina:       "c67616dff4843090436d43a165384b6309b55ab2f879755a12d84edfb8c594a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44e8e4299087649dbe8ea3bcd3c8c419cf457514cf01e58abb67a4aa34853b88"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"gitleaks", "completion")
  end

  test do
    (testpath/"README").write "ghp_deadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
    system "git", "init"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match(/WRN\S* leaks found: [1-9]/, shell_output("#{bin}/gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}/gitleaks version").strip
  end
end
