class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://nektosact.com"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.97.tar.gz"
  sha256 "807e43becd597f65c76c7d5dd6dbe5ff94285629214f6005ad18ce618b70e49c"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "667cd505d3dbbd35ef51b69936bc6b80cdc5ed2ffbfe01ada0967893cf04bd8c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7c2f8710328c6fa2dd9b9fbf593f620b7115a9a4d1303659c1a354c87cc5625e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "84dfd2a4378c0616c4d6513f8b56b69f0a54c5e95eb9fa48e3824492bf38337f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7729a87eb93a429df486a105e5e5c83b9862722d8138713af095176f94daab76"
    sha256 cellar: :any,                 x86_64_linux:      "01a6f9f0e640d390c9be9c54229c9414d98c9989996dbaf03352dd10e08b2f9a"
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
