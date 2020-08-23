class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v1.0.4.tar.gz"
  sha256 "8de9ddeed77576a4852c140c42197e8022f463b60e9c4b06978fdb12c3fcd4b7"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e1132f60f9cabf1bf1fd950933a86f149226f683c372626dd82ceee101ab6b4" => :catalina
    sha256 "04655d2c58171e26fa0d0976c087d4cf266ce43e9b0187b628c868cef65db254" => :mojave
    sha256 "4e883499aa21fac6c58ac98ea02d031ab7a411d4ee2784e35c4bff89ea357ee2" => :high_sierra
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
