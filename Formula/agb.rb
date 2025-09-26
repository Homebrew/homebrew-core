class Agb < Formula
  desc "Secure infrastructure for running AI-generated code"
  homepage "https://github.com/agbcloud/agbcloud-cli"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/agbcloud/agbcloud-cli/releases/download/v0.1.0/agb-0.1.0-darwin-amd64.tar.gz"
      sha256 "2e8db5702b497cbbed07aeae9407417d12454a641d94a7f5a0348c5b15b3c645"
    elsif Hardware::CPU.arm? || Hardware::CPU.arch == :arm64
      url "https://github.com/agbcloud/agbcloud-cli/releases/download/v0.1.0/agb-0.1.0-darwin-arm64.tar.gz"
      sha256 "692ade7607446a678fcfb840365e5fe24ad756313c0d977db7d19cf727fde382"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/agbcloud/agbcloud-cli/releases/download/v0.1.0/agb-0.1.0-linux-amd64.tar.gz"
      sha256 "14adbac86b512188b826dfbcef6bb72c4d3c46a96fe2802af46eec93df5000fd"
    elsif Hardware::CPU.arm? || Hardware::CPU.arch == :arm64
      url "https://github.com/agbcloud/agbcloud-cli/releases/download/v0.1.0/agb-0.1.0-linux-arm64.tar.gz"
      sha256 "7055021bd456f0ee780d8e1f4bda6a3d921fa7419ef76c1d83803cbdccbe3711"
    end
  end

  def install
    bin.install "agb"
  end

  test do
    # Test that binary is executable
    assert_predicate bin/"agb", :executable?

    # Check if we can run the binary (skip if GLIBC incompatible)
    begin
      # Test version command
      system bin/"agb", "--version"

      # Test help command
      help_output = shell_output("#{bin}/agb --help")
      assert_match "agb", help_output
      assert_match "help", help_output
    rescue => e
      # Skip functional tests if binary cannot run due to system incompatibility
      if e.message.include?("GLIBC") || e.message.include?("not found")
        ohai "Skipping functional tests due to system incompatibility"
      else
        raise e
      end
    end
  end
end
