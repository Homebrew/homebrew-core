class JsonnetBundler < Formula
  desc "Package manager for Jsonnet"
  homepage "https://github.com/jsonnet-bundler/jsonnet-bundler"
  url "https://github.com/jsonnet-bundler/jsonnet-bundler.git",
    tag:      "v0.4.0",
    revision: "447344d5a038562d320a3f0dca052611ade29280"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d90eef17450bddbe12e3bbc65d55d2b324a34f2cb36a028b32060e416e262c1" => :catalina
    sha256 "a42bfdfd2d149e8667ff0849de992e91160e78aaed6f72f2624f9a191c83fe75" => :mojave
    sha256 "e058cee6482accf6cc38bb4c404148464e4e071cecdb7191e1fbc6315e53f851" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "static"
    bin.install "_output/jb"
  end

  test do
    assert_match "A jsonnet package manager", shell_output("#{bin}/jb 2>&1")

    system bin/"jb", "init"
    assert_predicate testpath/"jsonnetfile.json", :exist?

    system bin/"jb", "install", "https://github.com/grafana/grafonnet-lib"
    assert_predicate testpath/"vendor", :directory?
    assert_predicate testpath/"jsonnetfile.lock.json", :exist?
  end
end
