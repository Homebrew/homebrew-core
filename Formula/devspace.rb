class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    tag:      "v5.1.2",
    revision: "95433b0ca0a5bfd1b44cc3e51c37e5ac29418174"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9d770b9ba0deb2192118988f481993d1eadf2106d9ec8c12922ff476f14f02e" => :catalina
    sha256 "9e24e67fce0119f89126a770c12b2389601146f564f43fe4124031708a987880" => :mojave
    sha256 "12ef559254c5636aebb70fb12c0d91cca671a58cc163d64ea98d917dfaaf2721" => :high_sierra
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
