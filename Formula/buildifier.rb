class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      :tag      => "0.29.0",
      :revision => "5bcc31df55ec1de770cb52887f2e989e7068301f"

  bottle do
    cellar :any_skip_relocation
    sha256 "d426e7e57b757a076c9cc6a34da79cb4e9756dec3c7fbed3a1905387c54c8576" => :mojave
    sha256 "d426e7e57b757a076c9cc6a34da79cb4e9756dec3c7fbed3a1905387c54c8576" => :high_sierra
    sha256 "cb8a814474d68e6450ba0d6d531438feb127cf3dff21022f8b116ceed657a9cb" => :sierra
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
