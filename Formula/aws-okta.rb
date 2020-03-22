class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v1.0.2.tar.gz"
  sha256 "bc2b2ff383f3b7e63acbea6b0dc9131bb30ac101885101a6d274997d5c3716da"

  bottle do
    cellar :any_skip_relocation
    sha256 "8647c8a1715974a8a1cc46a5b8a09a6075a0d209e6d65615c8b0443df8556010" => :catalina
    sha256 "8cf8eea3db470ccd75831e98107b0689b40e3f4212f11bea3d038d3e94c9b197" => :mojave
    sha256 "898f8d08ba4aa093b782fc52d119f02a4e679b1991d97dd0e787e62b3a062d96" => :high_sierra
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
