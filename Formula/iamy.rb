class Iamy < Formula
  desc "AWS IAM import and export tool"
  homepage "https://github.com/99designs/iamy"
  url "https://github.com/99designs/iamy/archive/v2.1.0.tar.gz"
  sha256 "3458668c2a6c82878807facb6858b52ee51b539aa51fd6b505b4dfa41a93649b"
  head "https://github.com/99designs/iamy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "70502c9a9e56883b3fbb2d4b7b3c6eef670c797624bbe7de50812ec2adf6f263" => :sierra
    sha256 "eab9f48a18661e6c016c01c822da39f9edf84c06b1a46fcd5ba5b07f138a309f" => :el_capitan
    sha256 "2691c8fcf937d4fe3887204cdec9836cb9123e747223eb5a324b21cb19bdd303" => :yosemite
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
    end
  end

  test do
    ENV.delete "AWS_ACCESS_KEY"
    ENV.delete "AWS_SECRET_KEY"
    output = shell_output("#{bin}/iamy pull 2>&1", 1)
    assert_match "Can't determine the AWS account", output
  end
end
