class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.87.tar.gz"
  sha256 "e04dcdcbc56741e2a5426814ae7c330e41f708d466838ad6e42622690b80af23"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31e04ddd1a5fc0ec333004ebbd4e99453ca4993fca875f8b3056cbf097990f41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1a968907ae281da480d5d964c9f771f4f786746816bf4548771558fd1a51efa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42eb590baec1fc6e3f783c2254d82c058578b787e3c02b85a4bcaeea97a8cf5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9506505c76e66d02bbab12fd3046b0683ddd44768fd27c779cd7fae50307c987"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdd693ca3f5c3b9f1720609da00ca7f4ce69969d2152440a2ee943467d1ba899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75dd3e14d13a5fea2a70d04c5ce4360d38f614f0f9583b849758e60f2ba8d859"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "dist/local/act"

    generate_completions_from_executable(bin/"act", shell_parameter_format: :cobra)
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
