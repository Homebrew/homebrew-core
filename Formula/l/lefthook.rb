class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.7.22.tar.gz"
  sha256 "c40e79dbc0feba5f0d7fdf8b9972316598d292c66ad294d1d57f62daa0524860"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41bea2f560acdc95d51fbaba55e5985c5328b6c998c7e0c018a29bc11c058f5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41bea2f560acdc95d51fbaba55e5985c5328b6c998c7e0c018a29bc11c058f5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41bea2f560acdc95d51fbaba55e5985c5328b6c998c7e0c018a29bc11c058f5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f2ffd8816730fcdb84c0bd7e4d58e9f56f7451b21b0b6bbd5d07ed756c16dd6"
    sha256 cellar: :any_skip_relocation, ventura:       "1f2ffd8816730fcdb84c0bd7e4d58e9f56f7451b21b0b6bbd5d07ed756c16dd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f073d0ad6b9032ba0aee5c9f724f69eb2859afaead5a6486887858dc5563e7ea"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "no_self_update", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
