class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v0.26.3.tar.gz"
  sha256 "e640610b29a5b501f9b3da3b9765106d3436fb2c980455b7e3d32687753f46fc"

  bottle do
    cellar :any_skip_relocation
    sha256 "970c382f66ba279b4197643378f17c5de9007d2b66448b9ed4e6581cfe8403bf" => :catalina
    sha256 "fd30c54113e712e65037fa9dcee81de3597a4aba9523771e99a0e3f716d33aa9" => :mojave
    sha256 "15364c7cbf7bd0725ad6ce3f00a4ed56fc3f9d4d4759d7a72d8f8f165c76b943" => :high_sierra
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
