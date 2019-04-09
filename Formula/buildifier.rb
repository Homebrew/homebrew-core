class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      :tag      => "0.22.0",
      :revision => "55b64c3d2ddfb57f06477c1d94ef477419c96bd6"

  bottle do
    cellar :any_skip_relocation
    sha256 "723a91cd55aa79548dd7a72775c6e89b394c5f8f81403265b0b9e37480404f90" => :mojave
    sha256 "723a91cd55aa79548dd7a72775c6e89b394c5f8f81403265b0b9e37480404f90" => :high_sierra
    sha256 "0a3f5e7f68bd1e075bea7edce8412e33dbba9650a6b99af85ef39c202fd09efa" => :sierra
  end

  depends_on "bazel" => :build

  def install
    system "bazel", "build", "--workspace_status_command=#{buildpath}/status.sh", "buildifier:buildifier"
    bin.install "bazel-bin/buildifier/darwin_amd64_stripped/buildifier"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
