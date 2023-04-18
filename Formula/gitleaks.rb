class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.16.2.tar.gz"
  sha256 "1636fcc82cc2a37c4e4965990080f779ddfeb69d7f49ef805d0d6e9a124a6dae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08106d1d5fc7ab1c4bca2986a459399afb2180097a3b973b540fd5232f66e9f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08106d1d5fc7ab1c4bca2986a459399afb2180097a3b973b540fd5232f66e9f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08106d1d5fc7ab1c4bca2986a459399afb2180097a3b973b540fd5232f66e9f4"
    sha256 cellar: :any_skip_relocation, ventura:        "5d86a6b1e3685d2ac99b040a7f11faabfa3a2d1bad0a882cf289b4c3dd545d21"
    sha256 cellar: :any_skip_relocation, monterey:       "5d86a6b1e3685d2ac99b040a7f11faabfa3a2d1bad0a882cf289b4c3dd545d21"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d86a6b1e3685d2ac99b040a7f11faabfa3a2d1bad0a882cf289b4c3dd545d21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60db4a0cb56628ece7d9ccefd2369f535ea03204e9c95dd7730cfd061acae594"
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
