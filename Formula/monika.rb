require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.8.0.tgz"
  sha256 "07caa733153f765a5ce570a9a6234a67ef09edf0fcb65427cb0706d08a0ed63d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "897ea7f3c4480efdcd86f445752eaead291592e100369b8343906704bb5aa27c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c87e41ada705a6d65ddd9141b5b184b7a14f0ecc0264266b9ca46ee0243044f5"
    sha256 cellar: :any_skip_relocation, monterey:       "371aa428b8d23fe9c28954c1c0b759868b129105e1a294639107681bf41527e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "520f49c4ee0d9549695931a900baf9eb7fae9c4b22898c39d47d3ab2b52cd1cd"
    sha256 cellar: :any_skip_relocation, catalina:       "94e2003b6a774030b63186a38ea1274e8a2f3575826644eb7f4fd754b63e70c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "584ee09b5a361d603dfec24efbd50be5a23147fb3c1f562bd200259f01c39c8e"
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
