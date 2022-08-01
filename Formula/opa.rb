class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.43.0.tar.gz"
  sha256 "c5ac0f4a2c50e347cbcdf97f711ef70f9d7bd8594f8d92036fdea78d34c8400e"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c68155af2f6afc87b61a98838d2fab8284c78e3f41a0f616d4a15e11aa240832"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba66295f566128c5838324efae88af81be43c526b9f14c37b8ba69aef2ec7ee1"
    sha256 cellar: :any_skip_relocation, monterey:       "10842bf307e0d6f84d57ec5fec49784cecb4b6862e6ff4fc3c718c65b1807d32"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b0f9b195a78e02b798ea9764d7169d215e1330af3fd387c83174ab9731c36a6"
    sha256 cellar: :any_skip_relocation, catalina:       "ed9dcf67936893a51152fa54384c035e8929cb4e04f029684835cb1ccafe2041"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b54128e385823fa8cfef681abc2dcc1abe076b9b44d24e6eb69c3a252f3d4064"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args,
              "-ldflags", "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    bash_output = Utils.safe_popen_read(bin/"opa", "completion", "bash")
    (bash_completion/"opa").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"opa", "completion", "zsh")
    (zsh_completion/"_opa").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"opa", "completion", "fish")
    (fish_completion/"opa.fish").write fish_output
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
