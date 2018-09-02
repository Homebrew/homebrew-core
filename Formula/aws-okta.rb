class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v0.19.3.tar.gz"
  sha256 "390d79982c79d8b2d9a4cc70d7a8346b73065bd54d493838dc3762afbfe3104b"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7fc915c694e166ea62877c1e83e2ca7db99be5e59bc92273f55bf9771410b35" => :mojave
    sha256 "11c40764931bd8be53652098336da7364b737254ad844ba87cfd37ebf28e7882" => :high_sierra
    sha256 "2f8697b34ee197750e2650724f69a8fdd2873a5c8a467ad4ee054ebf7b2e6064" => :sierra
    sha256 "8af21756f979f5f4f2f99d0a8df4cca4dd76edb026597bddd54bba241e40fd68" => :el_capitan
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
