class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.15.0.tar.gz"
  sha256 "a2fddce19f531b2adb679d1f353ab312b44b36dd4aa29be2b83b6d99da64e14a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e335d75118090826ee65385dcdd22b5e63785469c0bc3219b8e6a1e9357b112"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7f54a90c5a2ccf113f1736717159d663a05d68c4675f5b6d77a0346d4ee72cd"
    sha256 cellar: :any_skip_relocation, monterey:       "81d44d7768b209ede62789c9dcf82ec44e833c69adf6f587e29a11f034c1bd3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "65a4794b7733a8ef15e51d5a82ae9a21880a7fcc2beea5e62dce551edccc73a7"
    sha256 cellar: :any_skip_relocation, catalina:       "dd22faef15e7ee8e03201d58e6137d8aade646a31df28ebca3ad19f1f5922b3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c890c6ec9cf126544e4f36f479f3bccac62b104af88af1831523c6432210d28c"
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
