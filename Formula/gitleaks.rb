class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.10.3.tar.gz"
  sha256 "c5d907629da492fa0bfe267e616db309280feeb2f2ac7afd3c771784c2586476"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bd71f6f10794bcb5122fa36f8eba7e51d457621151fac292a6993661c7762c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5fca412ccd7981a0c1da22aab41e761d224d92e186cc8902938a0195415010e"
    sha256 cellar: :any_skip_relocation, monterey:       "c6c31eddcef8ed6acb1616c3c65524167e2102b84f3e0e728eb965fd7b341925"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf1fd589c3663706413d25d2aeac13270ef8b7a2328e8fd30b654f8755475d3d"
    sha256 cellar: :any_skip_relocation, catalina:       "6000ec3da733d93e454b62a9a3d140ecb4c4bf4e65c429d24544746e55b1b2d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d66b8bd9fda59fc137c2eaa592293c48181e068af0767c5bf45b4cd4fce09cf5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_output = Utils.safe_popen_read(bin/"gitleaks", "completion", "bash")
    (bash_completion/"gitleaks").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"gitleaks", "completion", "zsh")
    (zsh_completion/"_gitleaks").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"gitleaks", "completion", "fish")
    (fish_completion/"gitleaks.fish").write fish_output
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
