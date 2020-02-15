class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.5.2",
    :revision => "5a369be0ca726576d5b9147216bf7687c50c462c"

  bottle do
    cellar :any_skip_relocation
    sha256 "f171e5c9a245a2d7c7076ac6bbea40cb04e94dce09ff31f5f7191d3bbd4e2e68" => :catalina
    sha256 "d2b84d2cf291361077627df3a2b3329fe3162b15ff9639cc89b9941fe12d4767" => :mojave
    sha256 "d4eeb6bcb7bc1aa2dbe2baa28f7d73b6f2be04013a8e4b9ec56e0012d1de8d22" => :high_sierra
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
