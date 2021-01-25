class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v1.0.11.tar.gz"
  sha256 "444a84cd9c81097a7c462f806605193c5676879133255cfa0f610b7d14756b65"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "178f359eaabc71c8a677f89e1acb35fe73ae35ba4010a06876bdb630b66878b2" => :big_sur
    sha256 "6de4fd8fa42cddba3a914ed99123469230646bc2ac2598ff40fd0d0c9bf51efe" => :arm64_big_sur
    sha256 "2edc4ebb817ff4f0a3188a0c0eea6416ce2a83a6d9b5cc5b3969034ee65e27ca" => :catalina
    sha256 "910418c2dd89b78a7d665cdd8082d9941de433c6c8db800ce0515dfb6c1eb25b" => :mojave
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
