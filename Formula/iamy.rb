class Iamy < Formula
  desc "AWS IAM import and export tool"
  homepage "https://github.com/99designs/iamy"
  url "https://github.com/99designs/iamy/archive/v2.2.0.tar.gz"
  sha256 "be315753cd94a3652cfc0872f56e993c64ea0811247361742e3eb0be2ffcc64d"
  head "https://github.com/99designs/iamy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b53242a77b9f929dae108b63f5c98dacd8dbbb012c5b84aba2a32e3a568997dd" => :mojave
    sha256 "47472140d1784e319eea2d203722d957b588655234e266a3dab26be9fb103598" => :high_sierra
    sha256 "4d1e5b3b9bb838117293c18979370d395cd111f3c32f9b00030fbed7ae9c2f3c" => :sierra
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
