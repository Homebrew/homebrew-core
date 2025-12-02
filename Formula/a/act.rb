class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.83.tar.gz"
  sha256 "a3580ad7230b62f8cce189eb2b82956fd4447b546f41075b2f8070c963a56a1f"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bc94f409c769be7471a5058855037854d0a315427320d943f2cb96eadf0f80c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dff36c299fa12fa1c38681a9502c2172e1f168ea7769eaf53f41fabfbe31f5fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "042a2d98295314020be19a6154f0c3afd4ea2c7f79f844c48493443ee7bb4d25"
    sha256 cellar: :any_skip_relocation, sonoma:        "496a2b4a617fb84ed6c326017f5de32f5747ef665b0b58f506248ba75f630dfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f071605bffef4db91d8cffe803a52cef73d357fbefd0c1eac4a4a1bf639ef7f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecb27e8a141c3b2e34dbf3189f929cb1bd87779e1742f4cf3f59444f87801df1"
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
