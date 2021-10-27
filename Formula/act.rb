class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.24.tar.gz"
  sha256 "c6bc09cac52483e175f25d50a262e6b0815789a243a657b6b0c597f048487e0f"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e22428d1c18551bebecb98493eb4be72782e259cf15a0707ba0e92fcb808b553"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a20e74be00a60813dda3b8cf2ff6b15ee16127989b9b5e316796b311391997c9"
    sha256 cellar: :any_skip_relocation, monterey:       "90dac515cdb91ff6fa0b342de64efb8c24fe9691f6312976ebfd62765cd44d68"
    sha256 cellar: :any_skip_relocation, big_sur:        "dda88098e1615b3d69ea03a8edefde476ea2128427ee12915ef5913b3adde8c4"
    sha256 cellar: :any_skip_relocation, catalina:       "91b2522b430fc0a8045ef844633903b651432a4f355ce2e1b142ab35e55254bf"
    sha256 cellar: :any_skip_relocation, mojave:         "20e5acc8fe34351772ffee1367febe509045cf7abea85e24112040043b9399c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f09351f33ce63078e1b2e195fc7b12405b15bc90eff9065061972827aaa910ee"
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
