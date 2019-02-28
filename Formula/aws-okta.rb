class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v0.19.5.tar.gz"
  sha256 "dbcee4a2a6ed538c59b0ce4af9a09a486e69f060110c1d4500fdaf6785e76066"

  bottle do
    cellar :any_skip_relocation
    sha256 "47418e61636aee18b43224b8eb273f42d25670c1fe0e9deb366f7292487e355f" => :mojave
    sha256 "c9657ad4935bbbba5160731291a37f70a81f42965226d4066fff672b3cb83a5e" => :high_sierra
    sha256 "d0add28c664f631588a7ee4859f9b2826122d3ed63cce35c08f5f5321ead43f7" => :sierra
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
