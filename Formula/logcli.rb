class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.1.0.tar.gz"
  sha256 "ceccc4e42a7158ca0bc49903a3fbe31c8cd55f85f50bac8a8bba9843b4f8cd6f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c00781eb4b3e730f5adbc1761e3ef026200b7ef7009c052c2e745af71006c817" => :big_sur
    sha256 "08ac07823aeb4f80e1f634fdf344603d6450c8433f37cf0f646021839c5114f8" => :arm64_big_sur
    sha256 "4e1718a506115656753253f0795a22378ee3d0fa691e1fdd38334f6c1604d304" => :catalina
    sha256 "16c60bb03516466f2933aaac781a2a951120250caf03dd99fa27b2b214c03cc0" => :mojave
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  def install
    system "go", "build", *std_go_args, "./cmd/logcli"
  end

  test do
    port = free_port

    cp etc/"loki-local-config.yaml", testpath
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! var, testpath
    end

    fork { exec Formula["loki"].bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    output = shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
    assert_match "__name__", output
  end
end
