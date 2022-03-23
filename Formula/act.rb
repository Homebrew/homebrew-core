class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.26.tar.gz"
  sha256 "73d75205293bd18e4f529ef1aa47da79fcd7eda2413b790816f4ca63b7aa02ce"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c78735184593a5e15e0a8e64780847f6c99d742e684260a76372920dba886d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a32edcfb870f9673d308642dbef766605e638113aee43d50d953139ec4e8eec"
    sha256 cellar: :any_skip_relocation, monterey:       "2496ab9860c76d1bc812aefde82bdae3503b95971a0111a8c51841e301cce841"
    sha256 cellar: :any_skip_relocation, big_sur:        "aadf3bd1976442dd8769a0b246a49e518a7ae1c0f25f3d7cf6bbb21194b2534c"
    sha256 cellar: :any_skip_relocation, catalina:       "6b36d0a79c3b9e300c5cb46087ff9cf4529650e4f1c2b5e141cbed14a75b1013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efe487851ab306ecd77cdf30cd3eec49e1793ed26aded73f34c00fa8c2da4c7f"
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
