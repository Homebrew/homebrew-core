class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://nektosact.com"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.98.tar.gz"
  sha256 "4e572417b47a2bed56663d5a06ce60f6aa90e1cb4f6e103b9cae0dee852a0ca5"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "main"

  bottle do
    manifest_sha256 "7fb524ab28636f03a7cf6c5b471ed49b31017febe903721e57afa7d66df9c7fd"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "07e9a319d6bcaf3468dc12928b3b975b085d12aaa76eb33ae6da5c8669eb9f4f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "17c3348e31e2b884e85f1a69a7d6772185113673fd1b92c1539c19456ee86889"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf60071b349ae7e83f8f084c2b27c852c12c9d2aa8248144026ebe0328662b0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "85c642a61898d5b3736601e2350ca39476f8f706f033823d05e340ff0eb0cd9e"
    sha256 cellar: :any,                 x86_64_linux:      "69d2bd2d126151996a693b335d8339b3b6a2e47f8dd02b44c30f54e6a5675a8a"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
