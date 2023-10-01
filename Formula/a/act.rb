class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.51.tar.gz"
  sha256 "5b8d557ab72e9e5ee78663eadc7b9dfd0b9a68b7b381edeee527d77f60541773"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f17f9c99115415ee1ee3650700909bbf3fa082aabc4fe391f4cef9e61662d2d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d80e19da2db3381abd27da67af9d0ff626a1e6cef70a389fa3e9af073a797522"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92113c3149d39d69357dd9a3b2fc8abd70bd43e7c5f0df8dfcf3513df28ed891"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f86e5ec77f35945cbd444355a2dc60db63b00b8e5d319d2c23dc107a857c3ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "55d43aa6037f7d8f9b4100499fcad4a704878b38ee932004b2ce21e92617fddd"
    sha256 cellar: :any_skip_relocation, ventura:        "88c3fe6a5515fe74300af4f8a343ff2d23af1c53984001d3cf174f8ca46647c6"
    sha256 cellar: :any_skip_relocation, monterey:       "1586475e6a13fb17f08ef52fc3fb6f1200160634b5fdd70f717d5bb7709f1b6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d07fa20be3785d95f943aebd54abe93aada815b0ddf2d2edde92f4532a05b25f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e426943350bd0291db7e5429cb72de0cef92bc0839b148a3f013c9739270639b"
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
