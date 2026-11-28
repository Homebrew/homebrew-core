class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "be95ce5d07d23b036b48a600467aa4d1f67894bcbde414fb720daae749609f46"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    manifest_sha256 "c9cc9857eafbf1296f58d864bdc0b36ecddf7ba3b2e8d7675ce4ee7e7009bdc1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "35cee61de2f8f587cc0971726089bb91b1c8f55b687e9bc7c4312ee5257b6467"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "35cee61de2f8f587cc0971726089bb91b1c8f55b687e9bc7c4312ee5257b6467"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "35cee61de2f8f587cc0971726089bb91b1c8f55b687e9bc7c4312ee5257b6467"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f6c8dc787871731f6f0e91fe4c6e052f624aeea0617e21ab196c8492833872ad"
    sha256 cellar: :any,                 x86_64_linux:      "948eb5c56b7412fc909c8572dcd2afd037f2afae33b7133b52e4335e342a437f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/koki-develop/gat/cmd.version=v#{version}")
    generate_completions_from_executable(bin/"gat", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end
