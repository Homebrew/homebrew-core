class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v0.26.0.tar.gz"
  sha256 "e76e447ecb8d0e8c8e6365068e7f5caf290a752b6ed93680e3b6b2d1a106e518"

  bottle do
    cellar :any_skip_relocation
    sha256 "db0f39a8154abbcd40502855bc2d0b7bfa2fd292a55d0a00eaa6bceb77f0dbe5" => :catalina
    sha256 "843cc635f93c6a76f39280a1019ac822132b656118096d1a68176eefbc84d69a" => :mojave
    sha256 "66e3107fe9b86d3a4800114111fcc5ca8620bd444630e7420c138f3e500a8541" => :high_sierra
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
