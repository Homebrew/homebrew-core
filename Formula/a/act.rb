class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.78.tar.gz"
  sha256 "0376a119cd40a62deeb2f3a35f8d87a5fe054de0092d51448d147058c93ef69c"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3129a034dea7174a7632974bc4d5d3a28522b3e0f26ce726b4a56a5341c6d54f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ed9b4823e08d3dcf9878f11d431d67cf550e82567a1812afca0d771a2fcb905"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "372a0922c5f84e4d9eddb45b92933441de356d448bb52cd76a72dcaec904eaaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "68cff48057620950720392097971c2cac12cf4b1141d6dcc6d6b293bd7af7d23"
    sha256 cellar: :any_skip_relocation, ventura:       "ca1b7b72ad1ee02216acd9ac1e8a43aa614198ea9a725b305ccafc3de38a1619"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "331ba9d990635f0967070e7f724d2ee25bfec80be455078de1d55a0fc3623d62"
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
