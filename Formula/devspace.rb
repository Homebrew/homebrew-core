class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
      tag:      "v5.6.4",
      revision: "09876340af417c1c44d7804beb7a072ce812d504"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4af24cdc15bfbdadbe08845939034e7e5948efe702cb94559c6fb18e81b809aa" => :big_sur
    sha256 "06ac3af6f92c766b2f04650af3552883fabe426f397dc256038e93fbd6c34a59" => :catalina
    sha256 "f2b24a431874cfff38a1b654f09b029a037518e000461f444cc0a473063c27ff" => :mojave
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "go", "build", "-ldflags",
    "-s -w -X main.commitHash=#{stable.specs[:revision]} -X main.version=#{stable.specs[:tag]}", *std_go_args
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
