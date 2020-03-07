class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      :tag      => "2.0.0",
      :revision => "2797858400171ffaa3074c22925b05ed54b634f1"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e43331d6ffa2eac418857c30d53d97e428d08cb6267db09a06d259eb8b01aef" => :catalina
    sha256 "3e43331d6ffa2eac418857c30d53d97e428d08cb6267db09a06d259eb8b01aef" => :mojave
    sha256 "3e43331d6ffa2eac418857c30d53d97e428d08cb6267db09a06d259eb8b01aef" => :high_sierra
  end

  depends_on "bazel" => :build

  def install
    system "bazel", "build", "--config=release", "buildifier:buildifier"
    bin.install "bazel-bin/buildifier/darwin_amd64_stripped/buildifier"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
