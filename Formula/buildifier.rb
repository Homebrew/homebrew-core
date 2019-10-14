class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      :tag      => "0.29.0",
      :revision => "5bcc31df55ec1de770cb52887f2e989e7068301f"

  bottle do
    cellar :any_skip_relocation
    sha256 "14bf8461c8167aaa68020acb9c7ad939caa0c1979aa8eff0fb76b65131582ca0" => :catalina
    sha256 "9a2e2e7f8035bca4452c0a1bb5ebf640434e1773f509d8f270970f20dec21110" => :mojave
    sha256 "9a2e2e7f8035bca4452c0a1bb5ebf640434e1773f509d8f270970f20dec21110" => :high_sierra
    sha256 "1442768c1f74aeca76a6d288d8f2b210ca70e03ba0bf1b85e40345b389e67e9f" => :sierra
  end

  depends_on "bazel" => :build

  def install
    system "bazel", "build", "--workspace_status_command=#{buildpath}/status.py", "buildifier:buildifier"
    bin.install "bazel-bin/buildifier/darwin_amd64_stripped/buildifier"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
