class JwtCli < Formula
  desc "Super fast CLI tool to decode and encode JWTs built in Rust"
  homepage "https://github.com/mike-engel/jwt-cli"
  url "https://github.com/mike-engel/jwt-cli/archive/refs/tags/6.2.0.tar.gz"
  sha256 "49d67d920391978684dc32b75e553a2abbd46c775365c0fb4b232d22c0ed653a"
  license "MIT"
  head "https://github.com/mike-engel/jwt-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed4b9baea19b99b6bec2a3488e683b0354fd5633355a07c29c1db6390c0be8ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7620546fab86ed26262f53659f420a2a52a61137895e26c1e90ae0c8f93701e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbf28074fe942a8b9e56efdaa6a92bd420557f9e52efd34e20d0d8425081f99c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b47ec1157a9dea61645c802355907945b40fce48536af4adb46f7ebc99cb5b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "680cbbcf2e399fe52e9b2439cfa52ee5bce2b17ac2773bc4a82067e72a823092"
    sha256 cellar: :any_skip_relocation, ventura:       "60ffb058e6075cbbddd0b23ce137bc00679553f0d875e9db5addbf903dfb478d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2908de84a0365cdd926afea4a2fd75884d5ac24b757f17577c800fb6dc2015e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0489c4208b5020bee00984994a5ce2d8a2a1f80f67de14a43520f38e918f9b8c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"jwt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jwt --version")

    encoded = shell_output("#{bin}/jwt encode --secret 'test' '{\"sub\":\"1234567890\"}'").strip
    decoded = shell_output("#{bin}/jwt decode --secret 'test' --ignore-exp '#{encoded}'")
    assert_match '"sub": "1234567890"', decoded
  end
end
