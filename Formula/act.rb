class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.35.tar.gz"
  sha256 "8a8c027dc95ce402102baabf6b0249a71c594537057b29767b6b76da8d81e4b1"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49d867052b564ace082efd48c20c817dd1322e66d38daa3d24dbebf6f00638ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f10ca85d16b0c68e878125a6564343725c2c592a26f8c4dc7d9b5ed13ff92984"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e742a1f06e221f27b5c368bb39580a794b20206f13f87821de4c485511dd451"
    sha256 cellar: :any_skip_relocation, ventura:        "c05d3086fb22e183c8e0ed503ee55318eadf126b010907956406b7152cf131b8"
    sha256 cellar: :any_skip_relocation, monterey:       "793d30b1ae739a46c80da72d64166b9d3f2842bd84854b5c30327e77a650ebc3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3481fc5a1c4eff1577f25f58cbce443de332c275492f6361135dec450c5c0f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc0f6a3e51334f0880cf4f908d0cfbe2972a2e2a1649c4bff29f079278c00180"
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
