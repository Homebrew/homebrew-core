class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.82.tar.gz"
  sha256 "9a346d558672a23822f5fbfc020547a2b96ed4945e6c36dc239d9ac545cd64a9"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a26089eb2a99e0d946d16b5581319d253a00ef0cdf3a300a92773d8056b78054"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84e624a16ab7b533d99ec96dd19216206d3f76a563cb6c37079232b739e4c32b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31ec069c57b2b6260b6ef975ced230d57cb9a20d2016920cec770cbfb8666fa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d09d0a2d827b284c2e6521523c17935f04e13e64632e0ac100d90117872884fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdeeebae1c56adaa150f5f8ce4d736923ef2afd788fab7c90e420a1ad6f240e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "071b914efae08b41bf98e0179c8730f1b1f9e7394180eab49e30368c180fb8d3"
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
