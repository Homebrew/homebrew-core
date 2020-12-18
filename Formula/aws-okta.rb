class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v1.0.9.tar.gz"
  sha256 "030fdf10e25f0f3507a93f8b267fcb6939b77d714260cd757e741162c79a418b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1aa60743bc643a46d18ba5d7d771a95801a315eb24fe36d88b0456adbd9d114" => :big_sur
    sha256 "2cdea0519af672242bc8646bf0532ebbe9457434486111053fd6443763546ad8" => :catalina
    sha256 "01c36d36db51311dc275cce9b1bddb4b24fc729a9d3747cb4dbd9fae635ab6b4" => :mojave
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
