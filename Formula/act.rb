class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.39.tar.gz"
  sha256 "f3e27c1ffa0e873db096a23350fdfbf09d57a06f6789a15f4d3fb6220d34a8d2"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "101fb443cca685c9179ca6dd8c1c6721bb315a0c1c3ff67863834daa668b6e85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92851d16c63202818fe5b4bee3f11f39cb0e1f65abc4d3aa63f36576af266529"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac0c66353ec92588d6f806a4a4cc72e74406182b78eca918694f2392b15f67db"
    sha256 cellar: :any_skip_relocation, ventura:        "84688001ccac6b66769d6e79570b38ab4fa4a41c77f44bb0dac987d5a065aa36"
    sha256 cellar: :any_skip_relocation, monterey:       "2b0ac698570d42ba1b8cca82c7b67516ca0a7d71679fb23ff83602624fcacb0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3404c9de797ad5a737c7289a38e0b41ced9bd69de3ca271c8fef5de365f9eab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57b20a303bcb800fc54020c2963f90f1c4bb4805b4a3294cf249db99ba361ac1"
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
