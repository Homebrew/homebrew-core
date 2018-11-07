class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v0.19.4.tar.gz"
  sha256 "5bd6f81376cfa45ea5d0a067bed68e8dec14fe1a2f4bd7f4954db89172b32710"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf692e08b3054ac9b9f16a2fa3996fd3d4a888905ceb35c7496a535f21dd7b8a" => :mojave
    sha256 "455fcea7890c8c29446867192966f58a625287b36dc9a0760ab2a72f581b8229" => :high_sierra
    sha256 "101f4ea15a1a2dabb2932078ac846ec858718a8b9c65d4b1b03a5381abd52414" => :sierra
  end

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
      assert_match "Failed to validate credentials", input.gets.chomp
      input.close
    end
  end
end
