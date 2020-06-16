class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.21.0.tar.gz"
  sha256 "dde2c49e1d133216da8ce33b0d5276a00dfea18535ed91ca3b3fad514ec0175d"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3faef457e26a52818a60d168544cef7c5a7d54ef4b68e6cae2c9d1832d1113d" => :catalina
    sha256 "278a13e332b2624d511ddd4ac735d785670ed01f9b3fafd7b48fdafbb7dc7500" => :mojave
    sha256 "2d234a3fc7b435ae710bb7f11cdbf63763af8f8d77afa47a9dc771bcb1f01676" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"opa", "-trimpath", "-ldflags",
                 "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
