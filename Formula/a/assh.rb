class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://v1.manfred.life/assh/"
  url "https://github.com/moul/assh/archive/refs/tags/v2.17.3.tar.gz"
  sha256 "531cb10be20c86f464637428cc216525bb33e4651dc8aa801c09034521497172"
  license "MIT"
  head "https://github.com/moul/assh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c4f32ab8a470210c7c178888bb8b3d6570a246fea3a12a2e06c18ff987daeef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f0fe13a870813c624a9f71b6df962460481515f457666bec65d6058dad41b2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b9c43256e3a3cc9d43040a9b8697476ea965f653a5c1ee7e4478b9cc9596956"
    sha256 cellar: :any_skip_relocation, sonoma:        "552f9a8e8998f56f1b59f0002e118561812d7907e8448e591f5bf237dd3775ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4317f8468e5e966c5f5345686f55f9bdbd0e430b4969cf0f984fb81d7f66e7d"
    sha256 cellar: :any,                 x86_64_linux:  "039230b99b68a5546c8b85e8034175d70cfec690bd07c26ea59ebc38a6e45b6f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"assh", shell_parameter_format: :cobra)
  end

  test do
    assh_config = testpath/"assh.yml"
    assh_config.write <<~YAML
      hosts:
        hosta:
          Hostname: 127.0.0.1
      asshknownhostfile: /dev/null
    YAML

    output = "hosta assh ping statistics"
    assert_match output, shell_output("#{bin}/assh --config #{assh_config} ping -c 4 hosta 2>&1")
  end
end
