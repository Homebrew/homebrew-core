class Khaos < Formula
  desc "Kafka traffic simulator for observability and chaos engineering"
  homepage "https://github.com/aleksandarskrbic/khaos"
  url "https://github.com/aleksandarskrbic/khaos/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "fbc05cb87e75670ad28fe03cad653523df19689096db068019781897f01aabb2"
  license "Apache-2.0"
  head "https://github.com/aleksandarskrbic/khaos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab917aed0414ce0659c1b0d11a3cbe1ade7f9244d5c86ad51f4253f3e33af3ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8da1c7ab025d6f84c2287d62a48b1490ce091f53e27b6aee4dfd6cbf5afd241"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5fce163c3b439d1f67ebeb4b47f65056def5a30c4ec98aec6be991065364574"
    sha256 cellar: :any_skip_relocation, sonoma:        "b11654f58868b29ac97ce836618d635f490b87e3cb668577647235f4701b9cfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08f2aca076e99190f36171dfdd9057314e7b9567d7a966fa92c6e836482c49bf"
    sha256 cellar: :any,                 x86_64_linux:  "106b05afef63ef6967555e274e66b82aa3f552f3ea6b13b0ad50c29e9b7cba5a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/khaos"
    generate_completions_from_executable(bin/"khaos", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Available Scenarios", shell_output("#{bin}/khaos list")
    assert_match version.to_s, shell_output("#{bin}/khaos --version")
  end
end
