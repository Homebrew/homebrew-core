class DockerCredentialHelperEcr < Formula
  desc "Docker Credential Helper for Amazon ECR"
  homepage "https://github.com/awslabs/amazon-ecr-credential-helper"
  url "https://github.com/awslabs/amazon-ecr-credential-helper/archive/v0.1.0.tar.gz"
  sha256 "fa8a1e442fea42aab777c318a0c211e5cfc4572cafe22cc0ac8d1fd23a271e50"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5fa55bdec2cfc10e7e982c8d39672d62683a247d11c74fee946a5d2b6b9c922" => :mojave
    sha256 "6342b5e04907d8a5bbfd2b69634168adb9236e44228386ff53720f3a17906462" => :high_sierra
    sha256 "d4a9ec9dcdbee7acc2dbb7b1be639491b524b331f54673202e757105341c0904" => :sierra
    sha256 "400c8ba793f5ffd791e502ef885fb190cae45a194d1b47955d38f456959a154a" => :el_capitan
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
