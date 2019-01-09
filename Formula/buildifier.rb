class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      :tag      => "0.20.0",
      :revision => "db073457c5a56d810e46efc18bb93a4fd7aa7b5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3c17f5b5dcc56bea01dbc84796cfaea83fe4bc991a3c4ba301f7a2c74b4975f" => :mojave
    sha256 "9146773b6013b16d689769a97ca35b88f63ebfb905415618ad275569f1470f7a" => :high_sierra
    sha256 "eaae6bfd07289eedced6fec304145d68b297b52440ce4407aaf74a88d2862fe1" => :sierra
  end

  depends_on "bazel" => :build

  def install
    system "bazel", "build", "--workspace_status_command=`pwd`/status.sh", "buildifier:buildifier"
    mkdir_p bin
    cp "bazel-bin/buildifier/darwin_amd64_stripped/buildifier", bin/"buildifier"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
