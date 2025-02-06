class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.72.tar.gz"
  sha256 "bb4af8570bb9f2b8a455af6cc3dbc87e60be6db43e9ad4087c56b42f014c5d6a"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddee610ec229cb94ce0dcb5fcdc6f1659822d7737921a610cb704a2a080a7442"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47debdb1b7910ef9d6a23f1bc7847623dba421f6fc1aef06adc7809989d27832"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "489162994975e26fb53f62fce727887778fd75fc02465116bad4881c2935fb93"
    sha256 cellar: :any_skip_relocation, sonoma:        "728df0c8d9c9b351fb9eb98b72a02b66a8453d29234414c388186fb7f2b12f08"
    sha256 cellar: :any_skip_relocation, ventura:       "59729d23f986d93d91974cddb3c719d7530bbdc9f7d7192d8c1ac9d8f429a57a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2df8ab996f07de556805c6883f2d82f0dd976cce77b212943acf835a9270cda9"
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
