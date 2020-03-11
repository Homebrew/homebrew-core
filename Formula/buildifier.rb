class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      :tag      => "2.2.1",
      :revision => "22e56e7356b839fca53d4d20aff02e1a0dce32ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b0150e820a1c57da7e5964ea3e8c8f5c34f48b7baa94b0717e7f2f887944ad1" => :catalina
    sha256 "3b0150e820a1c57da7e5964ea3e8c8f5c34f48b7baa94b0717e7f2f887944ad1" => :mojave
    sha256 "3b0150e820a1c57da7e5964ea3e8c8f5c34f48b7baa94b0717e7f2f887944ad1" => :high_sierra
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
