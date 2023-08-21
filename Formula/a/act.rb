class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.49.tar.gz"
  sha256 "3e27111277a1dfb3dcfc6c5b3a81df1225974a379d0f10b253306ad44fb20ff8"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c7c68ddbd244bcd92be078f8a831a9c482886df5a436392db6de1b94e555055"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9026293530f2612ca54e93c87c33b8b6c8d66ea824247760150e671c27f00683"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fff5673949e0ec7f94ed6f020afebaf5274bf77717f56469fa3de28f7b4a7b9"
    sha256 cellar: :any_skip_relocation, ventura:        "6d416c3fc2d3ba8fcd6661da24e79a8324792aab3b9ffd00acb18c5d332f342c"
    sha256 cellar: :any_skip_relocation, monterey:       "ea199b6ae944135bdae25e3f42aefe085efd4716a3698d05607b24166cc445b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd67f4b4400f36b885f817f7031168482aaa19eb38a170c71bb0597117814a90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6b5907c171416a49660efd15b199199b5fa431f5ee11c8628a88b9f625dc11c"
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
