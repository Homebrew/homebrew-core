class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.65.tar.gz"
  sha256 "e5096be2d8fc24f98aed678ff5b9c5ed5b8eb02b667fdf15d79d265679480ee5"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae87c44d6033978e6adf2486c10d2cca81cb7ea6b48570f8fd410c2071ce049c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5eccda43f3acff8cd97c713879dd67c8b8db02754be88ee9c9926cb4a934021f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42fbfd03e36632397e27254db3e29b2f58dc167a482bbadb7383461740f408a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "745672ac4fe73556cb742aff90d2338ac60e762008b9f287c64cfa4a09fdd704"
    sha256 cellar: :any_skip_relocation, ventura:        "5d3a17b536255d3dbbc54977a8058e64bb0cfbb46481f202a45c28745d3d63e6"
    sha256 cellar: :any_skip_relocation, monterey:       "4093bb97d91fd55083eb9f2e0467faae40bda78a7b9524cb54ee98776c9c2e7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4befad5e57461c2faa1606dd391efd0e2d196fc3ce963e561947b8acffa8e5b"
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
