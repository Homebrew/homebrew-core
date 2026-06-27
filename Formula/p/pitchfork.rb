class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://github.com/jdx/pitchfork/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "926307dab53a77052d5b23337d5ee3185ead450783e4f1dc06617704279b87f3"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a157a55bc0eaad0ff303943e04af52fc4c2cb33e82486bbf12516af7cd3b7a49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dca9a13585db933b2cbfc6cb2d2f58222123b41d038826628d76bc524d8f7091"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d49f2981e0824318934e64bfef4fbeeb5e73ffca88712dd39c14c6f0307972de"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3d9595bcd12efa9845ced5b71be65f8f63975cc58651ad9a59f62947e1101ea"
    sha256 cellar: :any,                 arm64_linux:   "bf3b675b42cb22d059e4a80e79ea2f43f5612cdd503789bbd7b7aba1d0965e22"
    sha256 cellar: :any,                 x86_64_linux:  "67b92cb101b20ccac68197fe4e30ce2bcefd130dcd6a2ec032ff8b667ad39422"
  end

  depends_on "rust" => :build
  depends_on "usage"

  def install
    (buildpath/"ui/dist").mkpath

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"pitchfork", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitchfork --version")

    system bin/"pitchfork", "daemons", "add", "brewtest", "--run", "echo brewed", "--ready-output", "brewed"
    config = (testpath/"pitchfork.toml").read
    assert_match 'run = "echo brewed"', config
    assert_match 'ready_output = "brewed"', config
  end
end
