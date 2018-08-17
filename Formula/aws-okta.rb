class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"

  url "https://github.com/segmentio/aws-okta/archive/v0.19.0.tar.gz"
  sha256 "fc2c25fbbc95a2baf9d72504821a7ecf5e1d5561572cceda1c0656c90b8df46a"

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
