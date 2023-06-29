class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.46.tar.gz"
  sha256 "ca3f27316b0a0cf0f86203124d685dc13da090577ad459f3cd61840a66f2bcde"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db164cbf3a9702fb44f2a6cc3261a630005e5e87948f9fc1df4ce2a664424a3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f90b929437ae72844fa6f959d0e30b5c0d2c98d42c6b85829d887412ce3f9116"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "717a941d7dd659075b1e5d8d313dc26a3bc421513d118b741afa398c121250c8"
    sha256 cellar: :any_skip_relocation, ventura:        "ac536548a1b89b080311a508584d07e02adbe2a3d0319d72733fe8ae8fc67e8c"
    sha256 cellar: :any_skip_relocation, monterey:       "4afaec5a032c77436e5efc2abf8161b8a5d309c995ba9de99a7193e675a88837"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ad6a00f608a954d2681050d79c51a9d662952d55fcf59687bbcc8fdca24e08b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89427da311bb9243782977a709481da24b86d22e2a90a83ca57682b35d98a347"
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
