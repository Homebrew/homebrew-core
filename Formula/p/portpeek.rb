class Portpeek < Formula
  desc "Find process using a port with full details (PID, name, path, command, cwd)"
  homepage "https://github.com/erik-balfe/portpeek"
  url "https://github.com/erik-balfe/portpeek/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e2c40e4ea70bc01c4983c2d5cc830c4adff65963248b6b22cdea1fd44ba4ae6e"
  license "MIT"

  def install
    bin.install "portpeek.sh" => "portpeek"
  end

  test do
    # Test help output
    assert_match "Usage:", shell_output("#{bin}/portpeek --help")

    # Test invalid port rejection
    assert_match "Invalid port", shell_output("#{bin}/portpeek 99999 2>&1", 1)
  end
end
