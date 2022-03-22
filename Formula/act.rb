class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.26.tar.gz"
  sha256 "73d75205293bd18e4f529ef1aa47da79fcd7eda2413b790816f4ca63b7aa02ce"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47d3eb0fc2dbada73a1937c215287f930e9b03cf6a4879782349dd381778be9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85d3415d0a4094059f11e32e9b070559057765440b4924ddbe242702d7963975"
    sha256 cellar: :any_skip_relocation, monterey:       "bccab3b5369faf45d225c123636907f976b71501530854543a8253a83bb2b437"
    sha256 cellar: :any_skip_relocation, big_sur:        "47c7487e6912f21585dc65190ad55aa9eb242033f69f3cc301690f5f548eeb67"
    sha256 cellar: :any_skip_relocation, catalina:       "368b81473f0ecd36275e4a1bfaf46650a84d1460697bcbc401af7b4764c769e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ad2f9019a2f54b6871b0a9a00cdb30b09b010e3dab4600b66d25200d36e53c1"
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
