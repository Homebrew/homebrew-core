class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.33.tar.gz"
  sha256 "ac4a3171f3c98da1ef0b409635df7661a6fb282831cc27da4e7779bef583dc82"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf2950374861263dc55c29177bf0918e33ec669b5586da21276d32d1e23a0ef4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7a44c124a99bed2d24d870336470c99d843d4c7d12c3bf17f38d297c474e97f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f15e651950e39f051c74d76e699aca8f950ada419e93808cd516046a9eafffb7"
    sha256 cellar: :any_skip_relocation, ventura:        "1ec48d38252f3e90ff5c9d8277c302f9b0e845556f83007e1b0558f5eb08925a"
    sha256 cellar: :any_skip_relocation, monterey:       "a0f9ded7c9eff17a0f55211e657ec30ace59d9529788cb4296f8eb58f403d3a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bc3d121cd50152a7b2b6dd1bf3c3122f8ac881ae4e4401a890fa304011a4281"
    sha256 cellar: :any_skip_relocation, catalina:       "23d666af5737e9e586199b7cad12714d4dc1f61813634f517fd696f8d511e927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ac51cf298ef783e48c2469473a88579995b76f405d2a9e3a066a3e853571c7a"
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
