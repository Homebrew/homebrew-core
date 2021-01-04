class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v1.0.11.tar.gz"
  sha256 "444a84cd9c81097a7c462f806605193c5676879133255cfa0f610b7d14756b65"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "881e73a2f0d930d86e6acced82d09337495cc6ccfa75b20e5289dc81292752b2" => :big_sur
    sha256 "1d00b2be99691ee24c1d5f8991aadb197f098bed8525687c0de2b985e31d8bb9" => :arm64_big_sur
    sha256 "91ae8da87a6ce6e55d098e937fbd3ceb442f9e7150c01bd6d277b4e22bb408d5" => :catalina
    sha256 "b015f08f2f46be5f46479e451aed41005e205bccd1aed51e6b4497c6287b8d38" => :mojave
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
