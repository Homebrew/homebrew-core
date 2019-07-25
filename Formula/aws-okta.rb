class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v0.22.1.tar.gz"
  sha256 "a70419d6b611c50c0c34eb5882753dfce6a5e1e1e025e828c07c8e3a8c3372a9"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a407516b3eaa3b524b7e025202ea5d718e84ebc673b926e793ef57fe3679720" => :mojave
    sha256 "a2b516a20d8ca51d07b614a35ca731b39922d5404ed660bcac38cd861c4131db" => :high_sierra
    sha256 "d585624b5eb12ae61649f8837b814d6121d81f61eaefe3702a1f30f96b876087" => :sierra
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
