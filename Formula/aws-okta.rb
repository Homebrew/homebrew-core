class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v0.27.0.tar.gz"
  sha256 "e78813870d970dd3710d42d0993f8c437dedc6d888c3e72606e745abecdb6308"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f07504d628e8177e9e154fe4c5294398b7bb7b8368bae5541c8c1e5a9285702" => :catalina
    sha256 "542fd3979354bcc485f8ea2303a207c2bcaca43a3aa9680ac2fd3ec5b96bf04d" => :mojave
    sha256 "84c81b158267fd5dba50f34f72d203973afe6fc4355f78aefb2a1eb5d1d162d5" => :high_sierra
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
