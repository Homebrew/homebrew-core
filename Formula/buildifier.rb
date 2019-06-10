class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      :tag      => "0.26.0",
      :revision => "eb1a85ca787f0f5f94ba66f41ee66fdfd4c49b70"

  bottle do
    cellar :any_skip_relocation
    sha256 "87c05f3dec0b45f6ae609c9646aed2973476f5922c74e4a14de2bb3da2433fc5" => :mojave
    sha256 "87c05f3dec0b45f6ae609c9646aed2973476f5922c74e4a14de2bb3da2433fc5" => :high_sierra
    sha256 "58b0a2e0c2396b7557434065c52b911cf2f59bdc5756c1d6ec8a1537cec9002b" => :sierra
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
