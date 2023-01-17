class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.40.tar.gz"
  sha256 "ea7f9f119618bfb8ead50a065868743be1ea83fbb6f6129da74f5f5b4198dbc5"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87397faa4de4541c2128bd0de2a420a9c612c4a29a4a815cbbd839e87c2008d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d90ecb9578551f033f07c0f6c541df6c9b33255f916389a6d92ec92693def112"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2fce636b84f2d3c77e26745815cc6062752bc82173bd9dc54a36c15c9d1cd5b2"
    sha256 cellar: :any_skip_relocation, ventura:        "16f63eaf0243810e3f12be4608649ad979a9151c69237d970284d6b0cac1c2bd"
    sha256 cellar: :any_skip_relocation, monterey:       "7904d8f02020d0c4cfd4ec23fe930ab9800e93ab633bf8ee5ee3ddd270ae122a"
    sha256 cellar: :any_skip_relocation, big_sur:        "89bcfea7eee39a938793383e591e0e16f6dc90c08bd2d394912a8ab6b719f4d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "651f04547314edb881595cc7f42cc8e827c9d9a31526665ed85a36e778625c82"
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
