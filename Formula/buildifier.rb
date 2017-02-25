class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildifier"
  url "https://github.com/bazelbuild/buildifier/archive/0.4.3.tar.gz"
  sha256 "f6c092b44639fbb7ba11570c2f38a199d112e278ffba10df3dea5cefee3fe553"

  depends_on "bazel" => :build

  def install
    system "bazel", "build", "//buildifier"
    bin.install "bazel-bin/buildifier/buildifier" => "buildifier"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
