class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v1.0.6.tar.gz"
  sha256 "c73df8932f5f2e24662a423505cbaab4d0032ba89afe5790e16ea8cf64f63d51"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c32413e0519160e6a70de4c4120ae93e0fc296b6dd867cbf6f8b4a87bccd099" => :catalina
    sha256 "e60169eba7c34a8141f52de8abb256849cfc8ed09d403be36eb0ff872cd0d711" => :mojave
    sha256 "46837d6dac97716bdfa75e6433a48da228c05ec60922a5e6175ce535df94fe8e" => :high_sierra
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
