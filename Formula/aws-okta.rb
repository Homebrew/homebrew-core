class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v1.0.9.tar.gz"
  sha256 "030fdf10e25f0f3507a93f8b267fcb6939b77d714260cd757e741162c79a418b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbb99b6513adc118d36c9b595f0a8247770524bc7d0ecec8ddaf690def141bf4" => :big_sur
    sha256 "d041c7fec9fed2a7bc7c58b43a469b322eeca5982ecb87d7b3076b9f7cce02c7" => :catalina
    sha256 "bd6804f95fa77a2d9c7d8e322385c9e91474f6fd1a247aa0dc3786b872db42ab" => :mojave
    sha256 "6e92296d94f7cf752df9120f3a2ef92886de41aee43ecf91c426532ab80952aa" => :high_sierra
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
