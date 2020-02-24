class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v1.0.1.tar.gz"
  sha256 "a11f9f3dc08b9172b86244bdb19b6fd58fd919c7730f1c04cbb7ce3b09cedf55"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8eea0dda119799d437c0b5bc7fb2fb0fb7bb4e88d0cc7cd034192c0290ccddd" => :catalina
    sha256 "5095707ab4945c249c95a547f8cf8a91df76fbc2cdf36871e6f7b17936ed71b4" => :mojave
    sha256 "98ad1e9f70361d22e24300bb1c2eb9fb8e85107d37c06a081cd6b1f7ccc66d8d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=#{version}", "-trimpath", "-o", bin/"aws-okta"
    prefix.install_metafiles
  end

  test do
    require "pty"

    PTY.spawn("#{bin}/aws-okta --backend file add") do |input, output, _pid|
      output.puts "organization\n"
      input.gets
      output.puts "us\n"
      input.gets
      output.puts "fakedomain.okta.com\n"
      input.gets
      output.puts "username\n"
      input.gets
      output.puts "password\n"
      input.gets
      input.gets
      input.gets
      input.gets
      input.gets
      input.gets
      input.gets
      assert_match "Failed to validate credentials", input.gets.chomp
      input.close
    end
  end
end
