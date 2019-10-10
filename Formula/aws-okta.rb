class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v0.25.0.tar.gz"
  sha256 "dc97d44584ee007bd20d7d2824d3d114f998e755b407c9caf587f125dfe18e68"

  bottle do
    cellar :any_skip_relocation
    sha256 "677188862bf2b9a0c06176588092cc6d450781e916dd895fcbcbd307abd85b08" => :catalina
    sha256 "f9e49822d91fb51d73150b65d9e11bff61b154642f70198a9220d95e6bf5c59b" => :mojave
    sha256 "db91c45e126f73b6e66d00bb0aed859247e3fbf4dd21007d7a9f800647f5abd4" => :high_sierra
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
