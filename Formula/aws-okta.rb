class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v1.0.8.tar.gz"
  sha256 "85c97294eac8cd5f3d47b2d74244c7a397787206e3eb19e875c879b3718c8c59"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "777d0c9ec40e1a729e3f49a3a92a54e8c8e1ce90bb69456d73a04101b87ba857" => :catalina
    sha256 "ceef209f595070b174b806dbbadf716ede6b8dff3b76ee6a90b7173078bb0ae1" => :mojave
    sha256 "22de340f758bcdfc006e622f8fc12148cf6a6be76eea2d9e2f1d9952a778b816" => :high_sierra
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
