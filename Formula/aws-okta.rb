class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v0.19.0.tar.gz"
  sha256 "fc2c25fbbc95a2baf9d72504821a7ecf5e1d5561572cceda1c0656c90b8df46a"

  bottle do
    cellar :any_skip_relocation
    sha256 "98feb794d9aa6815ea069854d2c65661dcb8a1e7419ef9e07a8eebfb09faa77a" => :high_sierra
    sha256 "eebe1457c408b7ed7687d39248353eb113bc9d5cb8ef5a1310a5e8c2fd0221c0" => :sierra
    sha256 "8ac1a68120147f27b299ab203208aba3980cb47e08d0a1259b352ca6a96439e2" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/segmentio/aws-okta").install buildpath.children
    cd "src/github.com/segmentio/aws-okta" do
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
      output.puts "username\n"
      input.gets
      output.puts "password\n"
      input.gets
      output.puts "\n"
      input.gets
      input.gets
      assert_match "Added credentials for user username", input.gets.chomp
      input.close
    end
  end
end
