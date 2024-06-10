class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/refs/tags/v8.18.3.tar.gz"
  sha256 "b73ee6273198002f7c44cc38e4346d3397d6f083464a3820c3ff51145325f539"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9c4f05e71751982dbd1753bf6ee9d5fcadf7391e3d1c83ed3ed68a1b67cd3e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ef089e9bc919351152397f24f6cbdbc820137ac62511a083a51e4c6ba34fc0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "397d5416e3bb6a7c6a40ed40109456b3942289ecc7b8d5aa8d080a99211a2763"
    sha256 cellar: :any_skip_relocation, sonoma:         "58303deffd0031fd9e43c8c952da712680ca6ec63593413415d305242f3c70c9"
    sha256 cellar: :any_skip_relocation, ventura:        "06b41ef93c0efaec723513b2f3efcd79ec80992ebd2e4431d719c6899ec22ace"
    sha256 cellar: :any_skip_relocation, monterey:       "84ab9456378b141f2798e9c255a8671faee29a82b326cf9f7080cf7c8a9533ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e9f1bd63860bc8e942727307d1305e8b6b93d00c18df61f77620ede7337ec71"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

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
