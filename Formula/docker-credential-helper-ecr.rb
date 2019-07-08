class DockerCredentialHelperEcr < Formula
  desc "Docker Credential Helper for Amazon ECR"
  homepage "https://github.com/awslabs/amazon-ecr-credential-helper"
  url "https://github.com/awslabs/amazon-ecr-credential-helper.git",
      :tag      => "v0.3.1",
      :revision => "b4a1707cec17b0533a5b9e9004ef4b59bcd0ca95"

  bottle do
    cellar :any_skip_relocation
    sha256 "2454d0f49c6e753dda820f3e29b4b2ad342bfbe105f9593bb965ac90f0a92c4d" => :mojave
    sha256 "d4ea8e040cf60de713a05a9ca85ba0f4ae733316f2edfc26b3693b52330ff7d6" => :high_sierra
    sha256 "134b0228a2c77466523db446a0de5bd609564dc605290b50edc1ada7643a32cc" => :sierra
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
