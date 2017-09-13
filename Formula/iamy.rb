class Iamy < Formula
  desc "AWS IAM import and export tool"
  homepage "https://github.com/99designs/iamy"
  url "https://github.com/99designs/iamy/archive/v2.1.1.tar.gz"
  sha256 "c23e061ab0ebe8009e2db27fef95d733490a5a76a4f7d54bd1323ab8faf2441a"
  head "https://github.com/99designs/iamy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0032e8af26d5f19e127680b3c2a46edf8acfcdcc43705ec28c59c29b5cb7cf8e" => :sierra
    sha256 "e423ebfa60cb94e4af9d2bbe396c10791201f5be000da123981dbbce8bfca5fe" => :el_capitan
    sha256 "7711c9a181026bbb9f662fa04b08da34cff6a3bc7744b5e7546e47bf1615b1b0" => :yosemite
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
