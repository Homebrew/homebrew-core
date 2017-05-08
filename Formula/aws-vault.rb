class AwsVault < Formula
  desc "securely stores and accesses AWS credentials in dev environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://github.com/99designs/aws-vault/archive/v3.3.0.tar.gz"
  sha256 "2eb7ad97de31d55d61c87b26c7f361aa49f3386ee63796930373a57ef53053ed"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO15VENDOREXPERIMENT"] = "1"

    srcpath = buildpath/"src/github.com/99designs/aws-vault"
    srcpath.install Dir["*"]

    cd srcpath do
      system "go", "build"
      bin.install "aws-vault"
    end
  end

  test do
    system "#{bin}/aws-vault",  "--version"
  end
end
