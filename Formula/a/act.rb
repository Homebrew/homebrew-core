class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.79.tar.gz"
  sha256 "0a161cdaa1088b46691434042b2d7d1cec0df168c3601070d562bfc639c0b801"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4900c53b1d7438e9288b0b3ce70c5655c1cd45de439dfe201400732b9e95407"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e2c24f634259a2a09aa8874519b838495f2c660c00c7e25740ea3741718b188"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bed662ba4279e065633951498a8e99c6628bbd0177111fc2c87ecf04ff1f1ec6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f68b23498e2fc37c38b8db855c30fb84a58ee75daef7f626558fe64efe40a0a"
    sha256 cellar: :any_skip_relocation, ventura:       "e599ca5f75e7b2aa00a6d61f450501c558f10cf8f8815bf0181cccf4192055f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acccdd4f4d42ee898282ed25f17f8ae921138ae4b5b75235e126c12c6ed36a6b"
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
