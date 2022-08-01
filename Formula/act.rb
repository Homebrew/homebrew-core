class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.30.tar.gz"
  sha256 "ca15d8c9e1bac446c70cece6f244adcf6f7bfd92ce97c480bd54e97b5b77d54b"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dea6c0861d679a65c17dbeea836e570edb922b376ff5fdb84e7a3f39ef9a95e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ee03f3bf5d082e65d01cad6b881387310b4b575a015d33b755278ca89e83e7e"
    sha256 cellar: :any_skip_relocation, monterey:       "23648052317a39f3732852c05d904cb702b349c7e0afe900acbd978bf4b97ef7"
    sha256 cellar: :any_skip_relocation, big_sur:        "552b403fed087337c64097ba4728bf851ca63a7a2b129fa9c2e804b08d468da5"
    sha256 cellar: :any_skip_relocation, catalina:       "5960bdf15e709b8b795f8c3d0a6e15a1671b1db68e40aefec5d05c222544bf79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ab73131801c19e958829a0b351174439b31ecc4f043b7a79c40872b02dc217f"
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
