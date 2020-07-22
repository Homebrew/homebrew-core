class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      :tag      => "3.4.0",
      :revision => "b1667ff58f714d13c2bba6823d6c52214705508f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "05b148b61585416549120d37cc24be33b4852af2baa7a60785ab2a6df62ceb0c" => :catalina
    sha256 "05b148b61585416549120d37cc24be33b4852af2baa7a60785ab2a6df62ceb0c" => :mojave
    sha256 "05b148b61585416549120d37cc24be33b4852af2baa7a60785ab2a6df62ceb0c" => :high_sierra
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
