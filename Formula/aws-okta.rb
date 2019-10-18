class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v0.26.0.tar.gz"
  sha256 "e76e447ecb8d0e8c8e6365068e7f5caf290a752b6ed93680e3b6b2d1a106e518"

  bottle do
    cellar :any_skip_relocation
    sha256 "67e722b87142f217e803fb2d99374009bbe1bc217f71f5302c648b29d25aae35" => :catalina
    sha256 "c8e0aad89b2c4751110a6cce78df887f9a7b2b4a3500da7c2679944867313965" => :mojave
    sha256 "02e495de5e6d8010d78b906b998ec742d747ed404418cea7cbfdb6d16b7aca6e" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/segmentio/aws-okta").install buildpath.children
    cd "src/github.com/segmentio/aws-okta" do
      system "govendor", "sync"
      system "go", "build", "-ldflags", "-X main.Version=#{version}"
      bin.install "aws-okta"
      prefix.install_metafiles
    end
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
