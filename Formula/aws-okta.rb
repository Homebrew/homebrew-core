class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v1.0.4.tar.gz"
  sha256 "8de9ddeed77576a4852c140c42197e8022f463b60e9c4b06978fdb12c3fcd4b7"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1eec1257c8b1266c8722cb3c1d8f97a59ee0a75cf9c01d77a04be240951d4b3" => :catalina
    sha256 "d0ba7d676bf58d6702ebc1a6768c9713455e52d9c9ab9580838ce9b4c4eeabde" => :mojave
    sha256 "249029ff59e964bd1893822480b96e39bee0c305038fcb097166e9792b51c80e" => :high_sierra
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libusb"
  end

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.Version=#{version}"
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
