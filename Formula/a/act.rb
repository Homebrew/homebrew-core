class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://nektosact.com"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.95.tar.gz"
  sha256 "e30d650c4fcd13c5e1c2e634461858e22587ef81786c6c1c8fae7bd8a673767f"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "613845e791606a062cabfb941b920c13afe5fd81dc0479ca923bc95521a69993"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d18a32c251e8569a774a103af1fffd95a2fb5888ff72d5be0bfaf5da4962837"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ebd076709d6e1c26b549305cec1c1ece1d5db41cb3598412b8d70f21985923ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e524a1d570b2b8f12edea89b0ffbfeee4706fb71c0ab1628f4806b66cad0e2b7"
    sha256 cellar: :any,                 x86_64_linux:      "bda14c3293193e8e23bbd2511ae1e6260e0bf74413bf4f932be378bd2ef6f0eb"
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
