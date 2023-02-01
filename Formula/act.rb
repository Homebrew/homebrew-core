class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.41.tar.gz"
  sha256 "fcf80d1787be4da37aa62a100cb3dc1df307b5cd59a0cf179a7bf5897fec0f7c"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6825ade78ad5ba65981a29f22f0c88952ff67a9bb9fd780de6cc2878edcad0f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aaf98bcd77de7ace5276916fdefc307d063a377c1fbb4b58cb1dac9f7606d6fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a623f08dbf41b41bd4de2ec1e621e40398f4f534d4e6fb3ecba1647a10ad5f10"
    sha256 cellar: :any_skip_relocation, ventura:        "f21007fd776924bcc5e588189448c6c5015784171d16046c79d965490565c700"
    sha256 cellar: :any_skip_relocation, monterey:       "51cd0de32fd32907dac9e7412d44a8a7f690f6ab0649dbc5ede3247865a0aa86"
    sha256 cellar: :any_skip_relocation, big_sur:        "a46c0a522158c1df145c6e0436663be4764ec5b91732bd52949340dd8811d280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19bba51e4149c0ad0594d735b025cb87ba4ed197c49775102d98e941f55e2862"
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
