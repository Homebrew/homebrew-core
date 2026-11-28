class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://nektosact.com"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.99.tar.gz"
  sha256 "4dd92764a93c82e8a6a088424677b8eac4f77456e52d3de2b91bb9b21f43232c"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "main"

  bottle do
    manifest_sha256 "abf13eabc5ebdb9bccb30692a9739269eb99a21f552ada8ec7bd3f0168f2ffad"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "566e93d083f933aa4dee9c48fb91d71e684e655550f197b4b8631f8332ac3a03"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "54e1c0ec76c032aef7413523785006cc0828572431894af7340a3945d566ff6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c22154f9e4f20c3af6cccc49ed89c1e432497f95d1700499442a6713b7878329"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f47eda75ac9b9c6144dac104bca7a142434a6c7323ad51c38e1f88cec02373a4"
    sha256 cellar: :any,                 x86_64_linux:      "56d4fc96de83debc1ceb8212e78d38bce13ff1b73c8fb059c71e16ebdbb769af"
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
