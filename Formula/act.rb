class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.41.tar.gz"
  sha256 "fcf80d1787be4da37aa62a100cb3dc1df307b5cd59a0cf179a7bf5897fec0f7c"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e9f8d60720ce44eb2b2437b62530ab10b55e5eb4cfd5763f451cd2ea03d050e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce92a984a0fd8187f1df6542bc8fc1c096d4f9fb8be0642eb12f31df017f4e9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ca65ead9231ff3ca8ca10bfd92f0378c22daa37be403495e5edf2d5821888f6"
    sha256 cellar: :any_skip_relocation, ventura:        "f95db4621b224ed0be97cdc8bb58a44ffab2de868a0caa8c7cabf3fa66f33cbe"
    sha256 cellar: :any_skip_relocation, monterey:       "ecc6434192ea4b4f7df56e333b1851f9f0ade1f973e384878480c62f4081546e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e58eb83aa9806354e4453f1a12f05732b0902cc049e10341e14d1b24f0e166b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec53121d398ff3b773d8c3a7dd10e7e34686a9612d3f7f373ab43f31727f9734"
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
