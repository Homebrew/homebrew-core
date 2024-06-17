class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.63.tar.gz"
  sha256 "67832789cac6d66cf164c31f2d884cccca1343ae07a208f8152fa861f03de5a3"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bcd38f23c943eda625019480c2e13057acdcee151efd62c04445da776cd303b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8948256e4ec583b1d6ecfd1d3851f53c3b4ffc8d68005d15af05da4ee705a80b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed422d8609c597b73345533365dccf6534d3d19797017e8596079d3622bef5e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "87eda85fe3881ecc37710e35f7b2f005b7ba5d817d0aba80ff44c66499a3c68a"
    sha256 cellar: :any_skip_relocation, ventura:        "9820c7b2d2929b1c89cd2de76b9cb5a3cfa61f4e4673794f9702b086db87a953"
    sha256 cellar: :any_skip_relocation, monterey:       "b4936bb76e0ccc4b7d7b56fa3129d1aaed01860f4aee350856bfcf272766236e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e285b325ee7dce2e3a06e9b98d55b0a8790823c6f1ad9d11ac96caf5e2e1f0cf"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "dist/local/act"
  end

  test do
    (testpath/".actrc").write <<~EOS
      -P ubuntu-latest=node:12.6-buster-slim
      -P ubuntu-12.04=node:12.6-buster-slim
      -P ubuntu-18.04=node:12.6-buster-slim
      -P ubuntu-16.04=node:12.6-stretch-slim
    EOS

    system "git", "clone", "https://github.com/stefanzweifel/laravel-github-actions-demo.git"

    cd "laravel-github-actions-demo" do
      system "git", "checkout", "v2.0"

      pull_request_jobs = shell_output("#{bin}/act pull_request --list")
      assert_match "php-cs-fixer", pull_request_jobs

      push_jobs = shell_output("#{bin}/act push --list")
      assert_match "phpinsights", push_jobs
      assert_match "phpunit", push_jobs
    end
  end
end
