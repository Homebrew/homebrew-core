class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.59.tar.gz"
  sha256 "7be3ca3adeb80d15e03aa490fa88c7089ba5eea0877b3502d45339f5bc7c0321"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "522a8a044ebf3304a2330599c11700d16428680ba0fc440e703c69f6259fab56"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c7071a4168e2010e9851ba5db279bb0db7b3d2e8898d56e060d4701a1eb70f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e604057dd520f9ed50ccd930e2471bfbcb1d399702b6bd56c1bd8d4808141984"
    sha256 cellar: :any_skip_relocation, sonoma:         "b788ee971963732c5e616ac7ab3a49274c024a497c57097418820c8212d71b94"
    sha256 cellar: :any_skip_relocation, ventura:        "e0d94173cf1f74c03611ab4cfb6a6b8d7f53f60af68a76ea05f34fffcd6e1527"
    sha256 cellar: :any_skip_relocation, monterey:       "d7c2a4f35f0fae5e19ad82b423b08fc81385284f4a0d64d51af19ee503558ab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60ed8eba3f21bbda6a08e738a8ce8b4bca6868f0a609c599327520c72ebcb6f0"
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
