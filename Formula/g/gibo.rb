class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/refs/tags/v3.0.14.tar.gz"
  sha256 "ec6f3c82e57695b9fe8610b7c16d8c39a23769487a8ebf85408f661761b68c57"
  license "Unlicense"
  head "https://github.com/simonwhitaker/gibo.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d71ce2fe6af7ea2590c413b263c31d93fa0bc6d4277946a876fe504d6524241"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96cff6fc7f7729fd6079afe880c13d7be1c66ad72e2c1a6501f91bb599f64e49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96cff6fc7f7729fd6079afe880c13d7be1c66ad72e2c1a6501f91bb599f64e49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96cff6fc7f7729fd6079afe880c13d7be1c66ad72e2c1a6501f91bb599f64e49"
    sha256 cellar: :any_skip_relocation, sonoma:        "042bd7b78512ac7ca840430bff26d1c1c4651d449a94e2c72c66e0b8b852a04a"
    sha256 cellar: :any_skip_relocation, ventura:       "042bd7b78512ac7ca840430bff26d1c1c4651d449a94e2c72c66e0b8b852a04a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2676f6a0e1bc9345b4bacb4c98077c7ef0477eff3291e79c4ffae275b4ab2fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c5e560511609a96a820633f3d05454cad2fedf4eb93b07d1d6a22aff0c72602"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/simonwhitaker/gibo/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"gibo", "completion")
  end

  test do
    system bin/"gibo", "update"
    assert_includes shell_output("#{bin}/gibo dump Python"), "Python.gitignore"

    assert_match version.to_s, shell_output("#{bin}/gibo version")
  end
end
