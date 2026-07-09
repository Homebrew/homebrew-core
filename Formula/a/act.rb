class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://nektosact.com"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.89.tar.gz"
  sha256 "649cd5b91cad870871d2283fb3ad95c8fa1d5ced7a1db8d7b346d1a7dcd3ec71"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7160d747ebccc9567e63440d17f6b2e34fb8b2eb3c29f6f0f799270196a179a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4590846108557ae0ecaab4b237f6261b881e507c586159935ab662bcb2c3d3c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d7a57a0e211586db7df63f53caa2aa128c56850efbcb0d338de6892bf1d0fa0"
    sha256 cellar: :any_skip_relocation, sonoma:        "89b51dceceab1c24002907a8ea6e389922a62625bcd4275af3a82feb33258d5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ef5d5ad9ddaa902c13f1d54e1d510899d1c8fa400e36a5e311c3b50ed3a3b9e"
    sha256 cellar: :any,                 x86_64_linux:  "a6ce2149491416e54a5e7967a8d65bc3e8e5e05dab6bc09103cf0bc62e3a94a1"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall]

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
