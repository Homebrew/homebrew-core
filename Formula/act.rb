class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.43.tar.gz"
  sha256 "0565d6f72161d01ce61e3389e69186209e8971fa4fc9b9ed58814546be8fdadb"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f6da4b21da958545268c77bbf6d4ccb4cce89e75f50486e015eedb9af8db673"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "485c6c5216ed07370111dd7adff93ac9015bd285763bb75222f48eda93fbc18f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0523a488332666e7cd28c6624ff9662d82f2fa4a44dd1535c71232cdc0eee25"
    sha256 cellar: :any_skip_relocation, ventura:        "f4149e4b362cfe8240a80d1d9456eb62dc88ec8af8773c5936b780a24d780410"
    sha256 cellar: :any_skip_relocation, monterey:       "7c6d06644959cd87d2a54d995878b2e7fb53abcb4974798acd617b495a11a069"
    sha256 cellar: :any_skip_relocation, big_sur:        "78287a077db810177d9f8f2bb7b3b4848df0f7037783d1422b2802f89f02fcb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5311b2f6de703b16d74ddce41b36bf389b0f30b7440d37c15967adc1dbd8360"
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
