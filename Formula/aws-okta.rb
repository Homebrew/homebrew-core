class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v0.22.0.tar.gz"
  sha256 "765c728cd87f6153d738e76e0239935e2bfac0fffc40a5eca04f65746d9e0850"

  bottle do
    cellar :any_skip_relocation
    sha256 "da3d031a21db796229cefdbe19294adc22a9be5d6f2ee034305fc9c88d8aa7fc" => :mojave
    sha256 "80e1736abf7d5481d91f0c2b3c3191cf6813988f5fa96f8828371451355507c4" => :high_sierra
    sha256 "5050dcc42b71a1336f35fefdf1b49c81dcf4a02b39d9571f7c3b39928ebefe2a" => :sierra
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
