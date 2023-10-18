class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.52.tar.gz"
  sha256 "f0be3a2cf93361a9b012e87962b5e4f99e6b7900957ddb726a360d2527fcc7d0"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09284a2438b23199339efacf8ab77bb55a7e75f1aba79bad4bb64470ffbf1598"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8edc0b1ad3b4b70e0ff24f582276e028b8a9196cf412185382c4e4fea08ee713"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5989bc7fdbc46f4e9128210aaa64cc33ed940c423c2e849f132c6e7ecb21ed28"
    sha256 cellar: :any_skip_relocation, sonoma:         "51e6250227a9cde2e3017371d5be54a59ba0191305afc58f639ddfd60858dcd7"
    sha256 cellar: :any_skip_relocation, ventura:        "f1e2badfc9196938b51e8a5d80adcec5420646c7a8f286cc29b331035638dc21"
    sha256 cellar: :any_skip_relocation, monterey:       "b91215c65ee8136aabd7952d417b53379c192f2de743dee45a8b9e3fcfa50711"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0cd58e57df186cfb6b8888fbf65b24b870b827150da0e45c94baa6d95d2bfb2"
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
