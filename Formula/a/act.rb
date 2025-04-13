class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.76.tar.gz"
  sha256 "0cc577eba16c75016fc5a61f8d91a358cb9b470b601f5e14f0e94948101a31df"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "150301bc612e13cb91baa6f8922d4bd91106c8c4496adaf2120d0dc691b50f6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2df641f58acc8232539b372841c0ce28f054d5677431c3e220d6c25700ef8ecd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22a1e254e62c3beaabbaeb3247fc9bda89b7e4586707c329ee14dafc93912cd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f9cb0f31ae1294e279a75b322cfd7885c91d32ae9a4215e483c3c73e5e9d245"
    sha256 cellar: :any_skip_relocation, ventura:       "4ee92bd582f921e02153d3c6a56bf45997566366a261df7ed22db0626b718944"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f6421bdba9d5375ee86fb2a3492f304d64c136a9c7e7b71a09bff113a79d15f"
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
