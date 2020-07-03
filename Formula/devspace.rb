class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.13.1",
    :revision => "db7996b0004dae9ed7b0ccefc4bb0c0296a2a312"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf79d8d8955accaf109154787aaf3acaf86c690fb8e7413d8687253b04871954" => :catalina
    sha256 "e91c1177c4d744a2f84d909858e18337283e3319b32f8314c457cc57a032b6de" => :mojave
    sha256 "80217b01167d333179a4b9c584d30d0686572b711b718e2d9d291aa35a6e4bbf" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
