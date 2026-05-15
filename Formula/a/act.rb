class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.88.tar.gz"
  sha256 "a70c187ee403b53ead14b53296671528787734980b99d6deba029191c69ab131"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5b9a3ba9ddf9782ccebf0c930bb7a1f1f2e9f2760d157a07c9c03861f376f5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe57421127da1ba68e2789b2dc45c9a361d0a366669f43eb1e7614fd4c689576"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "848ff696dc99eec087e91d7a5bb5256cb7a3f33996f4613f77167ea306b8a040"
    sha256 cellar: :any_skip_relocation, sonoma:        "df61f544da978a0051c1f018f078b7f6ce93e13f30f375e5b9420d12006dd780"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b42a43205b7b0764e2d186b148c5153fca9e1ce68e109d8b75c35cfa17d1637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b46df2998362f3e4d101a7d28c3682460d5a75fc31a4b8f231c7b3ff653aae8"
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
