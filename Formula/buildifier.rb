class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      tag:      "3.4.0",
      revision: "b1667ff58f714d13c2bba6823d6c52214705508f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9d9ccbbbda5e795a4d4dff20f72bd0ed998bdce69356954f8f2aadc8690e978" => :catalina
    sha256 "e9d9ccbbbda5e795a4d4dff20f72bd0ed998bdce69356954f8f2aadc8690e978" => :mojave
    sha256 "e9d9ccbbbda5e795a4d4dff20f72bd0ed998bdce69356954f8f2aadc8690e978" => :high_sierra
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
