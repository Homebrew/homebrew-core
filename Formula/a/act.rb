class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.84.tar.gz"
  sha256 "da58b74d03b2cd21df81aeb054c2792054d6cf9d4c3171e98440fde9becb01fa"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd7f8f8ddd1c5ff74799385f0bbe6ba48dde0183c4efef4bc0db748b79b8a4fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "971f016d1664baae5e01f4cf121758d0ccdc38a850bbe4b383ecfe7a44e3631a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eda56bd1346ef6f88ccc863828fb2f3ae603cda56674cfdc2113317f66e9adeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b950139f4318116a06c34001d465644ea1c295a383e90eb8100d5a0f701b9066"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9be487dafffc4992bd017d7952416e843ec7d12e2221947f7b7d5bb3135c963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "879e746d6d78f4fb9e2cf53a4e9def25ee25f7339344bc1bef5d30a979b623aa"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "dist/local/act"

    generate_completions_from_executable(bin/"act", shell_parameter_format: :cobra)
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
