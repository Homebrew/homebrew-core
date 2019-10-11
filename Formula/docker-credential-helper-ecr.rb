class DockerCredentialHelperEcr < Formula
  desc "Docker Credential Helper for Amazon ECR"
  homepage "https://github.com/awslabs/amazon-ecr-credential-helper"
  url "https://github.com/awslabs/amazon-ecr-credential-helper.git",
      :tag      => "v0.3.1",
      :revision => "b4a1707cec17b0533a5b9e9004ef4b59bcd0ca95"

  bottle do
    cellar :any_skip_relocation
    sha256 "d68ac6324b9c68ba85b2626b074656f73aad6fd11b94605dc59c1313c5f20819" => :catalina
    sha256 "9342cc38595b09bff7c3fa711a503c60acef3ad443619d4d9176658842ce532d" => :mojave
    sha256 "a442aff2201f14467267465a3d472b1e4d91fe84393608d31a5339edb5d35c34" => :high_sierra
    sha256 "cd102bb19025f0123e153f40579c613ae063e81f14f4540129249853fafe5a3b" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/awslabs/amazon-ecr-credential-helper"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "build"
      bin.install "bin/local/docker-credential-ecr-login"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/docker-credential-ecr-login", 1)
    assert_match %r{^Usage: .*/docker-credential-ecr-login.*}, output
  end
end
