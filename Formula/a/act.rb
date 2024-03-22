class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.60.tar.gz"
  sha256 "e0067a2fefe7dfb47295bad361074ae29b35b17d0bff9602b507b0b96584c621"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d03a3ccdd0c2f22d290c719b88e5ab182f26fa5016fa2532689b6160d0998aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c2b4c675fccc4af62ccccb7a656d4f5be2613e20956e3e488500703546fb388"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a43de773db72b5859ec4095e52b7a756e3a8b03c0b8595d08e5a1b4a2f9f8c41"
    sha256 cellar: :any_skip_relocation, sonoma:         "62eccba08014eac4d559fcf57ebfd59ce85283735b5a7dc55f7086014506b9df"
    sha256 cellar: :any_skip_relocation, ventura:        "96fd8bdfd642a78c079b06b0e66eafe0ed76cdbe777101f9b84b52fa17a4d426"
    sha256 cellar: :any_skip_relocation, monterey:       "b41b0b1fdfdef0ae7592013187983b37b952a6021e67278dad1b3ec27f929f92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aefa4e8899387f458acfd220a2381c3e948722b9347af319d0a61abd2e9eccf2"
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
