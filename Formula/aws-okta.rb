class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v1.0.0.tar.gz"
  sha256 "3beeb38b3013094cd4b37bb08ff6accdcdbddb4212afceb5e2b114f01465fe6b"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "02d10c6d792f45046310509f092c3ee04d3ef9e634163368a8123160a2838789" => :catalina
    sha256 "92ac4c1d0b6fcb81323bada47c0aad22f6d45aed5abc2cc429d754c8d40c52d6" => :mojave
    sha256 "021aefbffe18d01beed3b60f50b875570db3023b8cd6c61ef4934c1e57148f47" => :high_sierra
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
