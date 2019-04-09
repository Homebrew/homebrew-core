class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v0.20.0.tar.gz"
  sha256 "f2c7d20a023d9a77b77568b6ec2e17bea1fdb408c90a28654a54395dd7d15107"

  bottle do
    cellar :any_skip_relocation
    sha256 "c83fd4fd1f9a720ea22ae94b9891ac387aba8c042bc46aa8937013ee168f7c99" => :mojave
    sha256 "dd2f22a1fbf658f3f928997fa1a13ea4a4270bc8fa30f0b894fa8849918e8a5c" => :high_sierra
    sha256 "a0a34ab324fe32de593bc7f60aa42817b724c96685772460e9b5942fe4e22dfd" => :sierra
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
