class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.68.tar.gz"
  sha256 "45653a9a73c8f5fe4bb6b05b49d3ef22589a6968ccf30a49cc399e7862870303"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e43c4f730de795f03fea88b32c36378ebde55b5e7567dc7d42d7e2aeb08caf89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccb2ad702660b6cc02ecbb92fc7a216a7d4c18f35de8dec4b86d7a0d8d376c3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29b5c833d5699d491e9ea007656abb027ff69b4df01231b452e3e0bb9449184f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c649251faae652c11eabb9b684c62dfc523756781aeb88a5815134fa1462c029"
    sha256 cellar: :any_skip_relocation, ventura:       "8a28158f375c52d7c3a401a0080d8f9de128651faa5b358174b1b500d6ee3d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84d7d7afa6e1a226fcf2edcc34693edb339fd8b961f0837a4817de08434aa194"
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
