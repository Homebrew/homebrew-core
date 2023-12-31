class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.56.tar.gz"
  sha256 "1af94bad393929299b51867b6455648a2ad82f30f657c1d5ee51c9996193c3e3"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90d6ebe6e860a985981d046af78a67da173cb5c1e5f8920bdb85d941feeb06ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a005b0f5e83f178f6b630e88ef225377eb25be5130895352dd718bcc0cc80ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "204ea7c7f7768ac4edd7708b4390324842e02604d3574ccefedb1beb2a61b2e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ad496625bfa45ce414697f6f46936c6352782dd90d5fd315eabb83d16484c00"
    sha256 cellar: :any_skip_relocation, ventura:        "daa12537a06f540471ee217d23a6ad4c8091bf6d69f7909486b3b4456fd41c11"
    sha256 cellar: :any_skip_relocation, monterey:       "696367ad1be4d173ecd87021f72415bdea013318b7f6c0b6e51363dc8ba07911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d955112010af308e3eaf6f00245fa768e6b963fc3aa8e922a22b144573725d84"
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
