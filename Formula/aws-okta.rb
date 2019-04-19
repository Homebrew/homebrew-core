class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v0.20.1.tar.gz"
  sha256 "a6bd7151cb56703716ea68a453058f5e1c1a8bf9c07cfa453cd3e8f7c37678f3"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9740bad6fb344ea4be94301e2f45566076e45422c7642c38ad78b09d75ac5e8" => :mojave
    sha256 "84d0e72153d73655f76d30c98ffdb447bf36d5e6e2bc43d53517838a30e06beb" => :high_sierra
    sha256 "88d68967866345e6f21966b05e6ed98f53e92cfe78b6c4556da8225d52d66bba" => :sierra
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
