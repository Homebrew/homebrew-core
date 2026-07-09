class Ctrld < Formula
  desc "Highly configurable, multi-protocol DNS forwarding proxy"
  homepage "https://github.com/Control-D-Inc/ctrld"
  url "https://github.com/Control-D-Inc/ctrld/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "a847e1ed6b4c309594c926e2d02da663b7481f6df448c7083912d24b9f97963a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b1de79cd824cdcc6e4c38ce75c01f4ff593e3aaa07c7c8bfea1fb52eafb9fdb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b1de79cd824cdcc6e4c38ce75c01f4ff593e3aaa07c7c8bfea1fb52eafb9fdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b1de79cd824cdcc6e4c38ce75c01f4ff593e3aaa07c7c8bfea1fb52eafb9fdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "21f6c5d62255ee644762b215eadc3456d98783e43f875731d6e6d4d32bb44353"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19eb82173741cc5d1adf286ecda7d976baf3eb62abec32a0005dee326a031ba0"
    sha256 cellar: :any,                 x86_64_linux:  "78688fa39bf1d02988a959c4f1f363ef1e8e199ca88b63558f8b091eb5d27455"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Control-D-Inc/ctrld/cmd/cli.version=#{version}
      -X github.com/Control-D-Inc/ctrld/cmd/cli.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctrld"
    generate_completions_from_executable(bin/"ctrld", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctrld --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"ctrld", "start", [:out, :err] => output_log.to_s
    sleep 3
    assert_match "Please relaunch process with admin/root privilege.", output_log.read
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
