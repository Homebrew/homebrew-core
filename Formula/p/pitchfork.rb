class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.en.dev"
  url "https://github.com/endevco/pitchfork/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "3c903458db95d208ad8852b938a272eb9fde005223c5e3867ea10fe9daa2e424"
  license "MIT"
  head "https://github.com/endevco/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a75694e98f6c745d9f1642fbec99940316f96a12e9a4c830c462f092756e9f50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9df396944aab1314c5beac44346dc9db6bbbf2bd212aadbcdc104a3cb0ad2ddf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "382dd9236e7bd4987456fafbb0937c2c7e70335172973c91c0c3fb2267a87ff3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f61afa701f61f2ec851892801586c048916a0dd86697605f80d8a761c939cbb"
    sha256 cellar: :any,                 arm64_linux:   "8a0b8cd6df59dfa676bd55e3a5bc0de585ea26e5f6d2a6adbb4d1c306e333684"
    sha256 cellar: :any,                 x86_64_linux:  "973ddbfecf30066c25913d69628f984b0c2efd65521ccb19e7aadf5ab13d7314"
  end

  depends_on "rust" => :build
  depends_on "usage"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"pitchfork", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitchfork --version")

    system bin/"pitchfork", "config", "add", "brewtest", "--run", "echo brewed", "--ready-output", "brewed"
    config = (testpath/"pitchfork.toml").read
    assert_match 'run = "echo brewed"', config
    assert_match 'ready_output = "brewed"', config
  end
end
