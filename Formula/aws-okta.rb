class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v1.0.3.tar.gz"
  sha256 "05a9bbac9d221c2232e72a4d49bd9ac3eadc2a722a13f64d4617951957eb7c91"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "8647c8a1715974a8a1cc46a5b8a09a6075a0d209e6d65615c8b0443df8556010" => :catalina
    sha256 "8cf8eea3db470ccd75831e98107b0689b40e3f4212f11bea3d038d3e94c9b197" => :mojave
    sha256 "898f8d08ba4aa093b782fc52d119f02a4e679b1991d97dd0e787e62b3a062d96" => :high_sierra
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
