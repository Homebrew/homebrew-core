class Hcledit < Formula
  desc "Command-line editor for HCL"
  homepage "https://github.com/minamijoyo/hcledit"
  url "https://github.com/minamijoyo/hcledit/archive/refs/tags/v0.2.19.tar.gz"
  sha256 "c89c66d480caa4365ba6318580964e551ce89b52087c44c6d73daa8a5d83623b"
  license "MIT"
  head "https://github.com/minamijoyo/hcledit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ee9942a766ff5c2674c6fafc20f5cb2329b731f17a4be00ae646d45d441b334f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ee9942a766ff5c2674c6fafc20f5cb2329b731f17a4be00ae646d45d441b334f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ee9942a766ff5c2674c6fafc20f5cb2329b731f17a4be00ae646d45d441b334f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ddcd6855be0a7538995124d36476590e98a934d10628c8dc21458ce5c78262ae"
    sha256 cellar: :any,                 x86_64_linux:      "f1594efba998e64ee6c4a31a93bb6e8dd6a480c1a46920ff79e9669b71c40101"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/minamijoyo/hcledit/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hcledit version")

    (testpath/"test.hcl").write <<~HCL
      resource "foo" "bar" {
        attr1 = "val1"
        nested {
          attr2 = "val2"
        }
      }
    HCL

    output = pipe_output("#{bin}/hcledit attribute get resource.foo.bar.attr1",
                        (testpath/"test.hcl").read, 0)
    assert_equal "\"val1\"", output.chomp
  end
end
