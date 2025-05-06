class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.77.tar.gz"
  sha256 "f0e43fe9416ad796035ad3b435dc6d8f6db6997d569f3e793d25f9ed7635f08d"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10e4a9debd5171a0594078b426ebf51224e8daddecdd4c5e17c7ed9243489c79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91ee09eb60be6ff814a890a16210153379bf658ba06f8677372c79eaa5a501c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6cbe0f56364ece21eaad866ab610b92b054e62e94c23ef1f3bc0765b674d899"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc2eee9223f4ebc9f460637cb6434af15c8e267988f92d4d28858f42c1170033"
    sha256 cellar: :any_skip_relocation, ventura:       "a9901a43735ff91b5f924173b51ea2dc5b23e5b587779e26c3ee9962a219969e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4956aa4146f211db41174fbe88409d2bae380e8ee2985cf2d6037f5b4786a692"
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
