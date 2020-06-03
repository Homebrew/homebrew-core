class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      :tag      => "3.2.0",
      :revision => "35db43bc5bf30a158ea1d2775402f51fac7865f1"

  bottle do
    cellar :any_skip_relocation
    sha256 "67ce2f67218024b89971130cd2469c30b2af1f80e1aa359845a8ad855cbf3d46" => :catalina
    sha256 "67ce2f67218024b89971130cd2469c30b2af1f80e1aa359845a8ad855cbf3d46" => :mojave
    sha256 "67ce2f67218024b89971130cd2469c30b2af1f80e1aa359845a8ad855cbf3d46" => :high_sierra
  end

  depends_on "bazelisk" => :build

  def install
    system "bazelisk", "build", "--config=release", "buildifier:buildifier"
    bin.install "bazel-bin/buildifier/darwin_amd64_stripped/buildifier"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
