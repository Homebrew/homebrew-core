class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v0.23.1.tar.gz"
  sha256 "e5fd1f761de98b65bf0780b29b33c0a2604f47eb077540b6375e2238a0083c07"

  bottle do
    cellar :any_skip_relocation
    sha256 "5763617f7dbfeab0f2bf6a676b9a065b9087b488ef123456e1526a0fef134f04" => :mojave
    sha256 "748d83aa80c376e7d5055af346e98e0b4d1981f57e49cb4c78423b4cf2e7d04e" => :high_sierra
    sha256 "8029446de9402b9670dad3c1862dab80017126b2cf90a963b4cbfcf277ef777f" => :sierra
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
