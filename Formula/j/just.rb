class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.42.0.tar.gz"
  sha256 "6fdbd6199b5469c70762a4991ae03d88fae42b99b48124ad7ad84808b67cdfb8"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a884933539c2720ae5839d35915f2bedfcb3f5b2fd3f571cb4f9055ad7e1b190"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38016228e478d6c3558b05f99754bba792ff4b24f3e9b225e78e3db6faddbc09"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1353447f3d5edd54baff10739c8b09fe68397c8bc36880626b45b33a6002e7ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8aed2a42f63a5fda5150adbbe4fdf7afb0910246f00c0932335126e4b90a5d3"
    sha256 cellar: :any_skip_relocation, ventura:       "639cb7b60c451825b1922744865c0aba03a476b1f95b4ee9309af443f9b327e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efa5b365dce5943bb85a1b33cf0e97a3d623a9ca2b267ebf2964d526e3cd82ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84f0fa06b05adce58cbb20ccc95a179b988a10e401b5dcff392e411da4911f60"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"just", "--completions")
    (man1/"just.1").write Utils.safe_popen_read(bin/"just", "--man")
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_path_exists testpath/"it-worked"

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end
