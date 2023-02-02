class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.42.tar.gz"
  sha256 "bc9f9d2c3f09ddc74b13ada6eeec2113cad1eb5e2d1ea03ba9438dff4d6700fb"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98490990b849ac90a9ac19e2abbed6622d90b42be509edc4480b72d2de042617"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51c937c20107f4503b02667fee9ed2eb90fe3268730ec49f9f7ad1547d62afee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1b79a55b6b857462084f3385745b419c14414ff73d585912587fa131e7590b2"
    sha256 cellar: :any_skip_relocation, ventura:        "8a8e27d75139ed39ebafac935e31af5b65d8a7723006d9503e333cbcbad07645"
    sha256 cellar: :any_skip_relocation, monterey:       "9010f627f487e6c05cd5eb3832225557278f80819037485a756067a6f10a7abf"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fe1409f0ce6b0ba7bc95a3cb8c3dc2a51a72185b0a076d966e1db67437f07bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e215012f7bde740735c7d35aea41d8b5205593cc33b4cba9d3e5748e06f0797"
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
