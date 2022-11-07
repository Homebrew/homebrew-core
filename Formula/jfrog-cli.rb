class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.29.1.tar.gz"
  sha256 "d7ba7626ccef1b4a0e07b99c98d329a0200a74a3005210be6511fab189e4bfb0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62b1e043a271dde74909edefbf8d88fa5c0b80f2bc4989914b63d1bb7a3667a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13dc70539d97be589ed8a87e9908d21bd91f979aff7710652c637bf5f65d0d9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ecc18f956d6dc91398fa13bd6477944aff4c68f9acabdcb52b9c2622e7df507"
    sha256 cellar: :any_skip_relocation, monterey:       "a3b500e891af823ae501a4c4eeb5db65d475d05fb87d2954541af2ba34ac3d07"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7b8b8a7af81e605acbebc3c46e5e7753be4cf8ba7f3af88f70224cf534f5640"
    sha256 cellar: :any_skip_relocation, catalina:       "44825f76bfd844d85a70d5e79d98856ae54dcd46fa41aaf81c5bfd4f3d1212a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa079f720a35de297dcdd016783e948c382652d9be7354c653b8ba5f5a98de1b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -extldflags '-static'", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion", base_name: "jf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end
