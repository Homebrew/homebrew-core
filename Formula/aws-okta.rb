class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v0.27.0.tar.gz"
  sha256 "e78813870d970dd3710d42d0993f8c437dedc6d888c3e72606e745abecdb6308"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "54de6445f3afddf77a59a4078d7381fd614fc80ef6e5fbc63e2d3de777af0517" => :mojave
    sha256 "ff1c50c64e064d16731dd30cf672999148ff98fdae81f85ea8c4c05eebf1a30f" => :high_sierra
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
