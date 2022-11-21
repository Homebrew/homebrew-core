class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.15.1.tar.gz"
  sha256 "0974f7ab931d3aa881c05490a06c5a92d8e1b52ea60166f4db3f37c2c4d2590e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0e87bd90daca2ab401cebf696e238e54717fedcab4d78806d48e684b20dc1ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f77b00b27cecd5c6db9faa42e35583f61c38bbd800b0ae1bcd46378992ec40ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05d57c534f6cae423602a6c05c299a6996745a928ca6bfc74578e15fac6381ca"
    sha256 cellar: :any_skip_relocation, monterey:       "e39f13fe19649b59c0f75e6d7bbaff2d339ceafce1fc3ec9ca6eb21f84074a75"
    sha256 cellar: :any_skip_relocation, big_sur:        "5460f9e33b0920793703e6b00dc39762fd324854fde381d26c2b1f4d5723308c"
    sha256 cellar: :any_skip_relocation, catalina:       "15313cc4d25c2df81bd82f52abd9e41807502d9b29172345eb17581e1b10c47b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "903529d36f8154950608e497f0e2a6fa012960d59b1d936798e94dba262a2b83"
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
