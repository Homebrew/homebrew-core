require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.15.2.tgz"
  sha256 "656a918ec6681df9c08dfca66bc4dd0334a7297718b1e0fec0e3c21af94ae055"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "844e88406c10b1f178b75a2ed6965e4d762a89d8684f17912df386c0aeb1b0cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "195bf219089dce7ef01a8e63d5db54b3a010b041ed90016ca0561d7b083f08a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b125f0da0f44dea64e7257468073bdcb5807ba74fcedbe065c354ac25987709"
    sha256 cellar: :any_skip_relocation, ventura:        "cc12af05f59f967c4f330af1cc05921b80cd4472b345a744c8d16d0eab86aa5a"
    sha256 cellar: :any_skip_relocation, monterey:       "aea0f953604f32de4b668198b7e7b21f4cf7d938f5322241b496b2eb266292ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "9dd616df68ba1b924deb7be6bb1413de364990dde054306a6598bc66530afac8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c35e0359cc11ed764d49d38cd8944b5a0d57fdd4435278b5be6442211fef3d7e"
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
