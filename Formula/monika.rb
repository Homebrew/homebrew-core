require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.14.1.tgz"
  sha256 "0dcf2ad68a7c71d1e196a742afda9fe7d02b056dd604aad1e159646d1e4a9aa3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddf7fa1f72c0bafa638601afa2c25b5fb7f8d9d89cc92d854031ba89745573be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e12edfca3ed835bb982673a851536255d9a14ea0b90232dac95424e762c6119f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36bbad5aa254368c416c892de247b2bee087c9c9e7bddb9d4a461e19a9a36009"
    sha256 cellar: :any_skip_relocation, ventura:        "18a581fc1e2b240233242870f8dc59c92839c28fae6b5dd6f5504c7d479c373e"
    sha256 cellar: :any_skip_relocation, monterey:       "fb2767701e8ee22b6c3e920c8145e6a410689485f5bdcf29ba4060f8c09a3573"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fe236c364472bb568a6b826a5a76fb2331c1c39dad6d75a94711c0278f75696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb7c4c6503f834389a08b151251bc4367ff10be911eabb2966532f41daa54bcb"
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
