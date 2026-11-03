class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://nektosact.com"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.96.tar.gz"
  sha256 "af2525e569e7d62cf164440d74c8467351b1791820909b17bcae8504097dd16c"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b95c35dcaa59b00e9a38b860c86a91a7464477d36d693fcb3c1671ae78f5dbf5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "722a59d7a8e75bfe9dc4e65ecef68551fbd934012b9d833c54de6c149cdd64b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf7bca5a6297a7e047a6dabcba44f3d662c31c3d56fbf21e67207fc0d16f1767"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b40107620aac107ecc9cb9a99a1d4c3f0d263525772cdb80bbec03104ba46dff"
    sha256 cellar: :any,                 x86_64_linux:      "5767b6aba78b0c465747283243622f88b4898ba0b1a702b186abf55977376c93"
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
