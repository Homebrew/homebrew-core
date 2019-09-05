class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v0.23.1.tar.gz"
  sha256 "e5fd1f761de98b65bf0780b29b33c0a2604f47eb077540b6375e2238a0083c07"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ca3c390ba3215495011a77bd50d13a5dc8bf33e6f2a232c30376dc5e978f434" => :mojave
    sha256 "397fea9c384c297d21ed0fc24036fb53cea6d22fe5ff3990e0d815273b61013a" => :high_sierra
    sha256 "cdd9fa500d41e596ed973525f7a12cddf39da8e3cc766a27a9632c3626d7e6e9" => :sierra
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
