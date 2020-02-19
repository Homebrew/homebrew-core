class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.5.3",
    :revision => "668366927c3708198a0996817b3ded39d52c8577"

  bottle do
    cellar :any_skip_relocation
    sha256 "21c5f12f0ce3323314e31e838408c6d12f5d92bbb1b8d0bd25a10119e0af0ae1" => :catalina
    sha256 "805c4d2c388ab8f5e25157f3cbe0c19e6c20b07ebd8875aa0de7613638401a72" => :mojave
    sha256 "2baa5736260fbe4a0f63501216ef5d17aa7fcc331a76a6e3ae79d177b15dd246" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "go", "build", "-trimpath", "-o", bin/"devspace"
    prefix.install_metafiles
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
