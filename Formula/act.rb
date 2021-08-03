class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.24.tar.gz"
  sha256 "c6bc09cac52483e175f25d50a262e6b0815789a243a657b6b0c597f048487e0f"
  license "MIT"
  head "https://github.com/nektos/act.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e938711ab984c9b367d2599129d241a1280c994a1d53a309d3de168c39672561"
    sha256 cellar: :any_skip_relocation, big_sur:       "a103cc9bf8400f08024dd4480ab6ea9f6997547f68284840c07786a98105aac3"
    sha256 cellar: :any_skip_relocation, catalina:      "71977c4592e29f6815027c79ea59b9faf62988364458f7daafb4dbff5c5e7b8f"
    sha256 cellar: :any_skip_relocation, mojave:        "66e0b453b7422e694d1085bd66a557c4a25999452f2ca805959fa6efda769132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12fe917fd161712dd0bdeb91c0c82765a8c62de43e752b6d260cfc74c6bceedf"
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
