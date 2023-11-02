class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.53.tar.gz"
  sha256 "7f1afc40dfda72a23e5bf03cf3077f859054ec7da3c2d03e923c1f208d73c49a"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "945054659ce7cabbac7e58acba68e2263bed0356b5f70eccb2dfb2f2f4a5c35c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "098d4bdea6872dc02f7e08e6a2aae2c3e9249d8b5e9bf653f1862b6f2f3b1bd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e40b13877d6c1fbe8c9f5c459f7f16ae42666a9704b096518dcc2aa2a823cfc3"
    sha256 cellar: :any_skip_relocation, sonoma:         "3113d749f4a1197f39b1a9e0c5bd43be0442b326afb69c3aa3c82d7607165eb2"
    sha256 cellar: :any_skip_relocation, ventura:        "3f3cd25405b76d3af7c7cae5d3f1081a3baed267cf3ffafe1a75067dad8ded3d"
    sha256 cellar: :any_skip_relocation, monterey:       "d22b6d535a25d9c199bf712633165689b154f6f3ee4b3f4ff7f3d0769239f65b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8ca187d5bc1f331bef06304037bf47eacd02e734ff73700952a046cd5630f20"
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
