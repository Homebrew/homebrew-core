class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildifier"
  url "https://github.com/bazelbuild/buildtools.git",
      :tag => "0.4.5",
      :revision => "45633988bb2b956f77c1075c4bc551ea3d7798b3"
  head "https://github.com/bazelbuild/buildtools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1dc5ed7aa5c8f53a0dd8717f7e9fb9eae44f9932a64b59631f15aa8d6af388a7" => :sierra
    sha256 "ab1074f05bcb7e8ac3c1ae3bc4c05c809ff4f8970f40cf500b3a81a99dc0e916" => :el_capitan
    sha256 "808bef097151f35b4e0400209fe4e465dadc373092ed5f05216523f9b34571ee" => :yosemite
  end

  depends_on "bazel" => :build

  def install
    system "bazel", "build", "--workspace_status_command=./status.sh", "//buildifier"
    bin.install "bazel-bin/buildifier/buildifier" => "buildifier"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
