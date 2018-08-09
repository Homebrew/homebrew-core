class AwsOkta < Formula
  desc "Aws-vault like tool for Okta authentication"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v0.19.0.tar.gz"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = p buildpath
    (buildpath/"src/github.com/segmentio/aws-okta").install buildpath.children
    cd "src/github.com/segmentio/aws-okta" do
      system "go", "build", "-ldflags", "-X main.Version=#{version}"
      bin.install "aws-okta"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-okta version", 0)
  end
end
