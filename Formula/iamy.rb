class Iamy < Formula
  desc "AWS IAM import and export tool"
  homepage "https://github.com/99designs/iamy"
  url "https://github.com/99designs/iamy/archive/v2.1.0.tar.gz"
  sha256 "3458668c2a6c82878807facb6858b52ee51b539aa51fd6b505b4dfa41a93649b"
  head "https://github.com/99designs/iamy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc541043b220b2157795ccd94af9d78a6d93f6db054c76a4832816b379c5249f" => :sierra
    sha256 "16cd74f1f6e2b22608819914b1c1e9277f5451f232ca6d0f53710ae571852cce" => :el_capitan
    sha256 "86cece8fa23de7515f8792f8d519ecdab504b12c1e7cb7645bebd95b82e926b5" => :yosemite
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
