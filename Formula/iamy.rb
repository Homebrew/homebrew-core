class Iamy < Formula
  desc "AWS IAM import and export tool"
  homepage "https://github.com/99designs/iamy"
  url "https://github.com/99designs/iamy/archive/v2.3.1.tar.gz"
  sha256 "abbc3f23afb8a57d02ec939a21ccac9fe0db18f96a742e03b16d32f3a8a12e1d"
  head "https://github.com/99designs/iamy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec31036a74b3e7fa56dc920b4dcb4f55dd525588a60e7e0306bccadb1101e11b" => :mojave
    sha256 "89e0a7f9d27d589ad0639f01160036e891cbbe811b28d45a5904e0a22aa66990" => :high_sierra
    sha256 "044aabaea888d7d318c8dc5f0319a33b9bbec6478ff45782ff5e1edec4eeb9dc" => :sierra
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"
    src = buildpath/"src/github.com/99designs/iamy"
    src.install buildpath.children
    src.cd do
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
