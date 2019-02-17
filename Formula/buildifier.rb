class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      :tag      => "0.20.0",
      :revision => "db073457c5a56d810e46efc18bb93a4fd7aa7b5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "81e0c48ab653bd6c4284b0835abdccad230b362a7ca318aeafc1a453057177a8" => :mojave
    sha256 "f8479028c5a943606489adbd3cbd1cecfdb6f88ccb619b91e046d14311e7364f" => :high_sierra
    sha256 "f8479028c5a943606489adbd3cbd1cecfdb6f88ccb619b91e046d14311e7364f" => :sierra
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
