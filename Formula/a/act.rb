class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.71.tar.gz"
  sha256 "042ebb0bd0bbd27803d09ebf4f257a7e90b05a5ff708eabab23b4cb0e25d6edb"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a21a1c839cf92d91ddb680ab2e8c672044a6482f9c3a7360506449fa075a278"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71a0922215b813d69233fab657c6d64a871b977268fbd74c3692d0c555d0c6bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a74f8641854df53c1300f7d482fa7fc3ba6e7bf501f2c5039ebcbf14bd46bd46"
    sha256 cellar: :any_skip_relocation, sonoma:        "215f80f2bb62baa5914712c2299802db563334298b81556e8c249d18eaa81059"
    sha256 cellar: :any_skip_relocation, ventura:       "51d98f26d20ba8ef83c6efd6166f26bb0071187e456812ed8b1a7adf2364c296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34aa36796e4668aaba930cc1ba809ba601c28a3572ecc5459d7762ab6e9c184e"
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
