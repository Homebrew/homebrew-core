require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.9.0.tgz"
  sha256 "38ad660016a82986102cec016085dc5adefa4c1b2b84371a8ee02c30394caf22"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb0c9f13d633fd175c17b547e0b3f587449b7ec0dcec6a02fa7141f60aab72e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68fb7bfeb74c771f6336762ac7f6ca614638abafce4f419d5e2b1ce142cb1eca"
    sha256 cellar: :any_skip_relocation, monterey:       "5ab1b9a18353f13807d28c475d6cbe638faaa1c16370130c86f8a4affde43606"
    sha256 cellar: :any_skip_relocation, big_sur:        "b98de1e772f4604edf7f0c3ce8a9a80848418c512c0f5fc265df069ccc52cd22"
    sha256 cellar: :any_skip_relocation, catalina:       "5dfd842197702ffadc51af19b7f8a72581b583c254b99c1e1e731f3c609e41ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9789bff5160d732e9f61fdeef51d1c5762833b4b7d574a6e9e4721f75eeee4ea"
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
    sleep 5

    assert_match "Starting Monika. Probes: 1. Notifications: 1", monika_stdout.read
  end
end
