class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
      tag:      "v5.6.2",
      revision: "489897cb21257fad80a3315b9d45ac37fa11b11f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "307eee98a01cb8060e7dc284de562f62c64e4f5907c1435d3067495a3cc6df14" => :big_sur
    sha256 "b666dbc82c1d7fd274e0a7b1c2844cfa6af20b20b714eb8c0f1df91bce334ae7" => :catalina
    sha256 "2b4912fade6a8aab7f3247be3be44a03814fc40472f7b61ed4d3b8bfaa5b2abc" => :mojave
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
