class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://nektosact.com"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.94.tar.gz"
  sha256 "0e1881bcf1cc9217d1ff8f4c5dba56004a0609502e55b059c0518f4c49153a9a"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bc6f111b75b7002c87506466aa920cce75d9f862870f138be80d0b32975a3505"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "78978b8c1b3a34917d5170d6dd52dc321d97fdc578c8e2bc21c07a05dac1aed1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e836b978b079763f463d2f754bf87f324abab6b440beb8e2cc5266c1dabdb4ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2ce5c4576b694b668fa3b4311252a404642a2730a3844720209ec48245bf4f70"
    sha256 cellar: :any,                 x86_64_linux:      "2b391c9e26ef7eb2cd0ae29b326b8e34b4d7546dba0897c44ae56162943ad79b"
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
