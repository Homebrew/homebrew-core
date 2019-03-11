class Iamy < Formula
  desc "AWS IAM import and export tool"
  homepage "https://github.com/99designs/iamy"
  url "https://github.com/99designs/iamy/archive/v2.3.0.tar.gz"
  sha256 "0bcf294e90e83985b6cef8f635091a0df70a6751dc9436e8304f1b2135428a7c"
  head "https://github.com/99designs/iamy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "03bc1dae355a2c7be4ab4b9beb7499c98631e94bc9c179ed1730fede35c4c11f" => :mojave
    sha256 "b64e1208a256256434da77d5fa96027963095f0a76eda6b0b0d6cb9e37bba0a7" => :high_sierra
    sha256 "9a1318eb21fbe17a3b572e8b22fcb2315e98d7cc8f1c0586e6305d0aa2d13994" => :sierra
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/99designs/iamy"
    dir.install buildpath.children
    cd dir do
      system "go", "build", "-o", bin/"iamy", "-ldflags",
             "-X main.Version=v#{version}"
      prefix.install_metafiles
    end
  end

  test do
    ENV.delete "AWS_ACCESS_KEY"
    ENV.delete "AWS_SECRET_KEY"
    output = shell_output("#{bin}/iamy pull 2>&1", 1)
    assert_match "Can't determine the AWS account", output
  end
end
