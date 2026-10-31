class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://nektosact.com"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.94.tar.gz"
  sha256 "0e1881bcf1cc9217d1ff8f4c5dba56004a0609502e55b059c0518f4c49153a9a"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82784edcb090fd27c8c0a3fd10b0bc8b0a8e144ebcb2ae08a5ceae1764e47af9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d2b3e54402e2ac85d7b6c65b27a2ea26b447a9163edd81f28c027e2b93d92378"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "de5925498e16bde9b55008348a2c205c635eda7c017192e3d0037c9a4347e316"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2b716f73e7274799e25fda21e38f521a30949d4563a021dc62cae41e996c730b"
    sha256 cellar: :any,                 x86_64_linux:      "0e82972fde56fe4d5340d75291252fd256732843c777c73ef3bebb8f78fd6253"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall]

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
