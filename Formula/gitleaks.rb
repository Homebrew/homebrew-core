class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.16.1.tar.gz"
  sha256 "203269c7eeda5129ae07536242e3dba8c850868582fb58827d81a09a0969233b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1ff14209e90d14e92e2f70e7251592d65e35cd23325271c2f8cc89f8d1d31be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1ff14209e90d14e92e2f70e7251592d65e35cd23325271c2f8cc89f8d1d31be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1ff14209e90d14e92e2f70e7251592d65e35cd23325271c2f8cc89f8d1d31be"
    sha256 cellar: :any_skip_relocation, ventura:        "92ef45151fec2dd56c9dc52805c39a93b19a74055c658201b180af10c010d8ef"
    sha256 cellar: :any_skip_relocation, monterey:       "92ef45151fec2dd56c9dc52805c39a93b19a74055c658201b180af10c010d8ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "92ef45151fec2dd56c9dc52805c39a93b19a74055c658201b180af10c010d8ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dfb4e6dffdcf8b8028c8677a1e1f9dd39a9e34242dd9a370016259734a0a1b8"
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
