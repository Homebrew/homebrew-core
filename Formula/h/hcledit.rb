class Hcledit < Formula
  desc "Command-line editor for HCL"
  homepage "https://github.com/minamijoyo/hcledit"
  url "https://github.com/minamijoyo/hcledit/archive/refs/tags/v0.2.18.tar.gz"
  sha256 "40be8406251263e90006853bcd336dc27b09fae93c56840dc3a44c3fd72f968c"
  license "MIT"
  head "https://github.com/minamijoyo/hcledit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26ef5207f2ea741c27c5a519cd59abdb614ec76ba88df2b5c952b636cfc0205b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26ef5207f2ea741c27c5a519cd59abdb614ec76ba88df2b5c952b636cfc0205b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26ef5207f2ea741c27c5a519cd59abdb614ec76ba88df2b5c952b636cfc0205b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d3c45b42e09e19149b5f1eadef9d07775c0382ed0d539ff86e40dbdd5067ed2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af426dfe5cbe58a7b8fae3280585c4d435409d69163488cd22e13f4403dcafe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fb5a34f86a074e3dd1fdea34d82c293e2a345a65b5f26bbbc348cb3b585964b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/minamijoyo/hcledit/cmd.Version=#{version}"
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
