class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify/archive/refs/tags/v0.4.12.tar.gz"
  sha256 "9f07788bb1e633ff5ef2224d8b83796c9d4dcbf776ad09e7e0759baddadf7167"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0bedcf4d29669f19c48de3309b4b8f101b0a555c12d3ad5bc9a59878faf1c904"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a8dd78bf86368314d77f421c22850845969e6c81dea0da3a8d176523f23b9fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05bfcc45d09546d38d0bc6db2c0a1b42d836af95825bf7505474c1fd4ac6326f"
    sha256 cellar: :any_skip_relocation, sonoma:         "6aa0d6044deaa0aec06fc6a2bbe1e00ff50437f24bd13147b36047b5451e8074"
    sha256 cellar: :any_skip_relocation, ventura:        "b37f3a79263b2137ed3248f2aa647dc42645ab9f6df26414c57cc53ad3abb447"
    sha256 cellar: :any_skip_relocation, monterey:       "0a931c8783cbca86b62ccc88c0175ff6eae8e39d19be60a9ed50e3535de0f707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e83badefb76c0ed31cd1ea014cd08997552ecd3d0f8989ec7946fdef8db7775"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/helmify"
  end

  test do
    test_service = testpath/"service.yml"
    test_service.write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        type: LoadBalancer
    EOS

    expected_values_yaml = <<~EOS
      brewTest:
        ports: []
        type: LoadBalancer
      kubernetesClusterDomain: cluster.local
    EOS

    system "cat #{test_service} | #{bin}/helmify brewtest"
    assert_predicate testpath/"brewtest/Chart.yaml", :exist?
    assert_equal expected_values_yaml, (testpath/"brewtest/values.yaml").read

    assert_match version.to_s, shell_output("#{bin}/helmify --version")
  end
end
