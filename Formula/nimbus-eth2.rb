class NimbusEth2 < Formula
  desc "Nim implementation of the Ethereum 2.0 blockchain"
  homepage "https://nimbus.guide/"
  # pull from git tag to get submodules
  url "https://github.com/status-im/nimbus-eth2.git",
      tag:      "v1.5.5",
      revision: "f0f9735955070d297b33fbec466537cb7029e0cc"
  license "Apache-2.0"

  depends_on "cmake" => :build

  def install
    system "make"

    %w[
      nimbus_beacon_node
      deposit_contract
      ncli
      ncli_db
      nimbus_validator_client
      nimbus_signing_node
    ].each do |program|
      bin.install "build/#{program}"
    end
  end

  test do
    assert_match "Nimbus beacon node", shell_output("#{bin}/nimbus_beacon_node --version")
    assert_match "deposit_contract", shell_output("#{bin}/deposit_contract --help")
    assert_match "ncli", shell_output("#{bin}/ncli --help")
    assert_match "ncli_db", shell_output("#{bin}/ncli_db --help")
    assert_match "Nimbus validator client", shell_output("#{bin}/nimbus_validator_client --version")
    assert_match "Nimbus signing node", shell_output("#{bin}/nimbus_signing_node --version")

    rest_port = free_port
    fork do
      exec bin/"nimbus_beacon_node",
           "--rest",
           "--rest-port=#{rest_port}",
           "--non-interactive",
           "--tcp-port=#{free_port}",
           "--udp-port=#{free_port}"
    end
    sleep 10

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{rest_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
