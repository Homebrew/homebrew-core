class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v1.0.10.tar.gz"
  sha256 "b82be6507428e1969d396d86696d6c24d6943716f1a5b412beef0683ce234f77"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1aa60743bc643a46d18ba5d7d771a95801a315eb24fe36d88b0456adbd9d114" => :big_sur
    sha256 "f4120a9e99a77029ec99b86459e2a786a06a317ed815d88ba6ce0bfd1be776ca" => :arm64_big_sur
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
