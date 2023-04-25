class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.44.tar.gz"
  sha256 "8b7afdc62dc5b1ab1f63fe6560fe6f0aad6e92beae78af82b8f417691c21ecd3"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ebb701bfc3e583930f0b7ce2b1be3d5ec7447fc5371f72b7f0d4681451532ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbf64bd7d5080b9806a6eff1cbd4f99844861898c8ddba83f3ceeae3a7938593"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c701199e9a4cad7385728922a471b52a90967008deb5cc85d1474c42241db14"
    sha256 cellar: :any_skip_relocation, ventura:        "0d05fe4cdffd9630e19e318f59ec8a87f10729eebd8c1e733fda44f15cf9a87b"
    sha256 cellar: :any_skip_relocation, monterey:       "cc2b0b1bde4d6308a3ed2cb61e5b3e1d8a81df9a7b6ab1944892d8a8d832e70a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a59e1a20879cfb4c2531ead35f6f95a345b1e672a4ffe40167de60276d981e44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b93b902f223f97581e8935486830b0eb045cbcf11c4bc23989f2ac70ab68508d"
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
