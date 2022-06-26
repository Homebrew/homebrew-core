class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.28.tar.gz"
  sha256 "010b9f02d2c431d9e09f5be1cf3099bd3fbab49043c53e34aa92b99bba8da3d1"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "271f88b2f5a6c89218ff72777400b5410905455fb4c3b4a7805554b23ea1e11d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66a693422fff57c4fcc10fc0d35dadddfeb6a8149c6d512560f6e463cadcfd1f"
    sha256 cellar: :any_skip_relocation, monterey:       "e6733f3d6dc2fcdc0a2b29b72763f500f20f469e6757108e81f80959d36d8c66"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ac7e074d64e8fce7d042fbaed0d88fe4b09efe03dada203bf86779771f60dc7"
    sha256 cellar: :any_skip_relocation, catalina:       "c13bc4b8989890a35ebbb630dcdb0f80171e83d0b88cdb8b5cbc3e25724fe8c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d767d5e5f94a165f2b505c77552c7d655b96fd9f437e818d76ec53d8cb415cd5"
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
