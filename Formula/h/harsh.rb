class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://github.com/wakatara/harsh/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "c0431d3fbe85807c4503738e49e0bd04700e4f70f9105e17c04a651dade4bbcf"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7bac101904f829044aaa4fe5c3f02be5df38203997a6706ce1ce3f880029b84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7bac101904f829044aaa4fe5c3f02be5df38203997a6706ce1ce3f880029b84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7bac101904f829044aaa4fe5c3f02be5df38203997a6706ce1ce3f880029b84"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdbd797695f7539f5ee44afa81e0e3b4463e87a083f0359d6e3d16c5feaf0af2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6f72e1cd8e9188084454f03dd2abca21042efd359247eddb91907e54a70921c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "657d7b50fd721eb7d7ac0efea36dbab57f61b2d66751d3f13610c9e73dcfc9bf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wakatara/harsh/cmd.version=#{version}")
    generate_completions_from_executable(bin/"harsh", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
    assert_match version.to_s, shell_output("#{bin}/harsh --version")
  end
end
