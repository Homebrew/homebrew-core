require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.14.1.tgz"
  sha256 "0dcf2ad68a7c71d1e196a742afda9fe7d02b056dd604aad1e159646d1e4a9aa3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5db3d7db631e41f588dad86447ec0d6d11eb0fd8bd03d9da8cce8c19587d7c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3e09218baa8ff82e9ba966b25d895c407858967a6193b7aa15b0cb7e9a186a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5e73b77ffc1b9c8de6f2f96ca376d80e573b5ecb21fc94cc3ec539b808516f9"
    sha256 cellar: :any_skip_relocation, ventura:        "4b23e0bb2fee076091f2d9d93390871d5d970b854501ec8d99437a299da24b3c"
    sha256 cellar: :any_skip_relocation, monterey:       "3f7a6f92749616f5bb31c7410640f28383c9e1234cae10514aa7f30f98267a54"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e7053d2626dbdd152e29bfe0ab184ce0476c56f87fdc07a63a6354989cf0f2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c285511be395046e5ce12d36cd69568cded2ad0737fa2fa255a21513cf61a0c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
  end

  test do
    (testpath/"config.yml").write <<~EOS
      notifications:
        - id: 5b3052ed-4d92-4f5d-a949-072b3ebb2497
          type: desktop
      probes:
        - id: 696a3f57-a674-44b5-8125-a62bd2709ac5
          name: 'test brew.sh'
          requests:
            - url: https://brew.sh
              body: {}
              timeout: 10000
    EOS

    monika_stdout = (testpath/"monika.log")
    fork do
      $stdout.reopen(monika_stdout)
      exec bin/"monika", "-r", "1", "-c", testpath/"config.yml"
    end
    sleep 10

    assert_match "Starting Monika. Probes: 1. Notifications: 1", monika_stdout.read
  end
end
