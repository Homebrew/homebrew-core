class JsonnetBundler < Formula
  desc "Package manager for Jsonnet"
  homepage "https://github.com/jsonnet-bundler/jsonnet-bundler"
  url "https://github.com/jsonnet-bundler/jsonnet-bundler.git",
    tag:      "v0.4.0",
    revision: "447344d5a038562d320a3f0dca052611ade29280"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "make", "static"
    bin.install "_output/jb"
  end

  test do
    assert_match "A jsonnet package manager", shell_output("#{bin}/jb 2>&1")

    cd testpath.realpath do
      system bin/"jb", "init"
      assert_predicate testpath/"jsonnetfile.json", :exist?

      system bin/"jb", "install", "https://github.com/grafana/grafonnet-lib"
      assert_predicate testpath/"vendor", :directory?
      assert_predicate testpath/"jsonnetfile.lock.json", :exist?
    end
  end
end
