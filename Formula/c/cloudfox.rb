class Cloudfox < Formula
  desc "Automating situational awareness for cloud penetration tests"
  homepage "https://github.com/BishopFox/cloudfox"
  url "https://github.com/BishopFox/cloudfox/archive/refs/tags/v1.13.4.tar.gz"
  sha256 "599ec6f7d341e973cc0a72b03b62955c9b75d3cf503dfb23eab51894afa817a9"
  license "MIT"
  head "https://github.com/BishopFox/cloudfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c10f7f646392a20e69e4828f1887f4a4137d4d67dcbbc1fdf2f13263d21de77a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09b3dddf23cee9b32ec0e7fa68deb07611d6199c6ce15925f23cbcdc439456b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "062b801e25c4350700b3098fd7d5befb7ffa2024771e1c0a56fcc2a209b9e4c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "a32325b5cfc030b3e5c22fc38ef9dd5bbb1c6552efdb30a71a6cf6a3db4f2cd2"
    sha256 cellar: :any_skip_relocation, ventura:        "7b5b9fc54e0aaf651097a2c8512bbbf397869d0b94891c67a627f5258f180f58"
    sha256 cellar: :any_skip_relocation, monterey:       "c06b19b0543635cd4a47759a6a48d34b8d90384ec6b6953499156145670d5a36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49e60dfe10ca7df672ae53fb3756a3b663b3636c6b5bcf86079db2f66e970003"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cloudfox", "completion")
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}/cloudfox aws principals 2>&1")
    assert_match "Could not get caller's identity", output

    assert_match version.to_s, shell_output("#{bin}/cloudfox --version")
  end
end
