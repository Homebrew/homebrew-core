class PactCli < Formula
  desc "CLI client for the Pact Broker"
  homepage "https://github.com/pact-foundation/pact_broker-client"
  url "https://github.com/pact-foundation/pact_broker-client/archive/refs/tags/v1.77.0.tar.gz"
  sha256 "a7f333afee6eae511c177256a284fc30d7b236bc4ab715107303d99353555664"
  license "MIT"

  depends_on "ruby"

  def install
    ENV["BUNDLE_VERSION"] = "system"
    ENV["GEM_HOME"] = libexec

    inreplace "pact-broker-client.gemspec",
              /`git ls-files`.split.*$/,
              'Dir["lib/**/*", "bin/*", "README*", "LICENSE*"]'

    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "pact-broker-client.gemspec"
    system "gem", "install", "pact_broker-client-#{version}.gem"

    bin.install libexec/"bin/pact-broker" => name.to_s
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/#{name} version")
  end
end
