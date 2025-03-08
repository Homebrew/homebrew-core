class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "e8713d5e7640757103b0cd78fff923623d6e042f404b5d9c655f715690750bd4"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "323018f4190cc059b6470d34312be9a2c0ea3898dae4d669a648bd0c6267a2d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "323018f4190cc059b6470d34312be9a2c0ea3898dae4d669a648bd0c6267a2d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "323018f4190cc059b6470d34312be9a2c0ea3898dae4d669a648bd0c6267a2d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "28ae80e49e5f07df3b1c3e2b40e940b0f8f2364695e83f3caae4576389a5beb6"
    sha256 cellar: :any_skip_relocation, ventura:       "28ae80e49e5f07df3b1c3e2b40e940b0f8f2364695e83f3caae4576389a5beb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efa73a03fe73b0255c47eb88e0a3d4d3a21671fc11400685429c2374810d809e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "no_self_update", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_path_exists testpath/"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
