class JsonnetBundler < Formula
  desc "Package manager for Jsonnet"
  homepage "https://github.com/jsonnet-bundler/jsonnet-bundler"
  url "https://github.com/jsonnet-bundler/jsonnet-bundler.git",
      tag:      "v0.5.1",
      revision: "451a33c1c1f6950bc3a7d25353e35bed1b983370"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c12a0b7fa5a7ebfd3390975141ef9270041d16cad5e50ac2c037250b063ab3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fca099b90eb7ee638a511421b92a18d62976a27f26daadc81591c62780009df2"
    sha256 cellar: :any_skip_relocation, monterey:       "c5e1dfd5b88514d02f92c58561d8fe999920df9484240272986c10c2f61ebd61"
    sha256 cellar: :any_skip_relocation, big_sur:        "adf174c8284ad175985632eff78208530c367d6522f364b75964380433706a5b"
    sha256 cellar: :any_skip_relocation, catalina:       "6b1a393f6110771bc8b8e241acd1f6a4c86d9fe66f2148a39ffc2ecb3ea411ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2123283a83d290e3106e6adeee62832ae7b9f352f785909bd08b52fb712e6fd2"
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
