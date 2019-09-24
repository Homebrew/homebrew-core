class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v0.23.2.tar.gz"
  sha256 "65c88c95d2546a6766a742fa55987435153844f251de043097361da6cca3c16a"

  bottle do
    cellar :any_skip_relocation
    sha256 "a273b6f97515b18e54293f60b5053b43ff34e25372a6f5dfd9b96e6b4d3a39ef" => :mojave
    sha256 "9827ad1b9c8416668cb07dd05048edeeac9f5481c4eab56bab139acdb0dd7fda" => :high_sierra
    sha256 "fbb2b9a2162435174024f5bcf0685698ba39eea3630877926daf328115a3dd85" => :sierra
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
