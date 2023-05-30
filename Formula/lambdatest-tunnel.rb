class LambdatestTunnel < Formula
  # Fetching Sytem Architecture
  arch = Hardware::CPU.is_64_bit? ? "64bit" : "32bit"

  desc "Package for LambdaTest Tunnel"
  homepage "https://automation.lambdatest.com"
  url "https://downloads.lambdatest.com/tunnel/v3/mac/#{arch}/LT_Mac.zip"
  version "3.1.31"
  sha256 "87c34de6a80ede137e0327fb4ee25ce06b0a7be1ee6d51ddda86d0dd6450fb8f"
  license "Apache-2.0"

  def install
    arch = Hardware::CPU.is_64_bit? ? "64bit" : "32bit"
    system "curl", "-L", "-o", "Lt_mac", "https://downloads.lambdatest.com/tunnel/v3/mac/#{arch}/LT_Mac.zip"
    # Unzipping binary
    system "unzip", "Lt_mac", "-d", bin.to_s

    mv "#{bin}/LT", "#{bin}/lambdatest-tunnel"

    # Making binary executable
    chmod "+x", "#{bin}/lambdatest-tunnel"

    # Installation success message
    ohai "LambdaTest Tunnel is installed!"
    puts "To run the tunnel, use the following command:"
    puts "lambdatest-tunnel --user <name> -key <accesskey>"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lambdatest-tunnel --version")
  end
end
