class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.81.tar.gz"
  sha256 "d1766a9c07cd8b47af4f2008e15098ec70729bd232bde73a400724e4467d0e23"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1afda55ad36ea7e108b31f0c899dea56c88d6892cdbde5a5918f9201aa2aaa79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3387b2a31a14d72723d8837168eda49b524eefd029198e6c926a6f45f4d6ac09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bb11d06568ea07852ab4e1f52cc798949f23af1805f4d9d8785ac87e48ddc5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "772f81884908acaac66c15e42777e3d53d310d87642ddf2f9eb4f2ebdf0dbe8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bf027a57b862af6a000c851d9caccfb1f0f193a0fd1385134c2caf06a641722"
    sha256 cellar: :any_skip_relocation, ventura:       "18e91e0954adb2e61dbc975e1031d68968db0c8a6581297c3a141f6000e36349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19d6d8d873a29c4880b4f572865a131e40a18b267622ae571b6b9dedd36ba4e7"
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
