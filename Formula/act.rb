class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.19.tar.gz"
  sha256 "6058f4c2b6a6bffa1cf4a37b65e94216eec56d4766927a2610faa0e177309452"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "073ec3c987e044b3f730a5e451884c74390f0521c25e3d887a4fcaa511608175" => :big_sur
    sha256 "d2bd2042f26d5a8be7454c8e5f2ab636691f02d99aad91ecafa6b1f1018ba631" => :arm64_big_sur
    sha256 "7cbf53abcecbf19075fdf1199998c61a0c6c3fd8dadf40e6a1295fc866169ebe" => :catalina
    sha256 "39ab75db53d6260817eb8c2169d40fdf77b681f5c42470a21cd341f3b7eb929f" => :mojave
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
