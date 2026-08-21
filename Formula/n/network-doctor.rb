class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "277d9dc0907f38e1fbaf8213a3c89fc942d27909767aefeb00ce6640f70aa9c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "417102165cf14ea6a3d351e1c8289ab9e66c1a78bb75f19f6755fa81f7c08ff6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "417102165cf14ea6a3d351e1c8289ab9e66c1a78bb75f19f6755fa81f7c08ff6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "417102165cf14ea6a3d351e1c8289ab9e66c1a78bb75f19f6755fa81f7c08ff6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6027c7ff03f54d39c56089846739f91962f4f2153d6344e08e129fae4177287d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59429ecdbb69a5a2d05ff1c701191d1cd4c5c395c3568722fdb2095ce2cd59a2"
    sha256 cellar: :any,                 x86_64_linux:  "abcfdd2bded9d1caa519154945c6a50024a44b99ab4242d253b8783d1ec0e234"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: bin/"netdoc")
  end

  test do
    output = JSON.parse shell_output("#{bin}/netdoc -json")
    assert_equal version.to_s, output["version"]
    assert_equal true, output["checks"].any? { |hash| hash["id"] == "iface" && hash["status"] == "PASS" }
  end
end
