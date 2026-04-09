class Hcledit < Formula
  desc "Command-line editor for HCL"
  homepage "https://github.com/minamijoyo/hcledit"
  url "https://github.com/minamijoyo/hcledit/archive/refs/tags/v0.2.17.tar.gz"
  sha256 "007e8ba0c8be6272793fc4714cb60b93cb4cdfdc48ab5ad5a6566e44f99d200e"
  license "MIT"
  head "https://github.com/minamijoyo/hcledit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c12e2f1d81a8e8ae4218c5959527a8c3fecd0335c47be6a009ff9fa379656bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f337eedfe77241c8a1e9e1be22fcc53322fc34343950d7cb7a52908f5452c4e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f337eedfe77241c8a1e9e1be22fcc53322fc34343950d7cb7a52908f5452c4e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f337eedfe77241c8a1e9e1be22fcc53322fc34343950d7cb7a52908f5452c4e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b20a51f695f3783df9862c041c4c969061476b870efee585cbbc0e676c49542"
    sha256 cellar: :any_skip_relocation, ventura:       "0b20a51f695f3783df9862c041c4c969061476b870efee585cbbc0e676c49542"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8f3385b7a443e2bcaa9316779682f28c1c3a5e97231c96be9d7fb98e01da984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "502832282bfe2438b7fec2233905a46cf484e94240e86b854e7fdc85bd634603"
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
