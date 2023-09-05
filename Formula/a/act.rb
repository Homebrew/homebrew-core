class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.50.tar.gz"
  sha256 "90f479dd7bc4e93c7d6817fd709752bd3225408bfe31b4b042bf516c90795c7f"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea83ade58f41063dbeba98f87adb638df7adec49bc4c2199d0cd90bdb559461d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "291cf3e210f218651a69cf843cc37619e73e1d40dc829f4e0201c7058b9c52f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "376108167ea9a0c73a8d9bde93daca425bbafff5ad66e6f8e657c1074567f29e"
    sha256 cellar: :any_skip_relocation, ventura:        "9e84330e698e24227daee888927067aece100dad5fee57fcafb74bcad14d7bf3"
    sha256 cellar: :any_skip_relocation, monterey:       "55faa7d1daa35ab31b9c2f1924838610c2fefe52af37127806484e71a0eea0f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "10c86819f31b812ad584b4769d498f607217955ff53c05145b6f54de3f953fe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fb6e600c0e854500fe4ced47eaeb71767f6ad6b4e8bc6959a6f16054f16b87b"
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
