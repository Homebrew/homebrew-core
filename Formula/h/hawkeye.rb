class Hawkeye < Formula
  desc "Simple license header checker and formatter, in multiple distribution forms"
  homepage "https://github.com/korandoru/hawkeye"
  url "https://github.com/korandoru/hawkeye/archive/refs/tags/v6.0.3.tar.gz"
  sha256 "339a5d9b9461637b90b518158568607ba50bda4f27799af40d6cef28436255bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea5793271a325cee369ad2297073eec9d999887339fbb0df05faaf9cc62d95c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ee33048b4858dcc734d160fe1bb86f2d66dc78f56052751a3c5432540642b14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af72ecfda55801481b2c1b66fd7d82aa61f42547a0954bff20ce301d6c610956"
    sha256 cellar: :any_skip_relocation, sonoma:        "9db1a87051b178dcaa1ed321fb2a2bf79aad0e27bec75002728e3f738ee34d64"
    sha256 cellar: :any_skip_relocation, ventura:       "6ecd32e655b3321a0e0090e34d31810be8853eab976bd3317a877eb5c174e5d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08aca455279a8e6bac6b9cd02c12f47ae7293cff514264f902435f81d79131ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5487fcf1de1b759ccb3eef7688d2dcdd12f1803b542edd9f32fa229ef7fd37c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_includes shell_output("#{bin}/hawkeye --version"), "hawkeye \nversion: #{version}\n"

    configfile = testpath/"licenserc.toml"
    configfile.write <<~EOS
      inlineHeader = """
      Copyright © 1970
      """

      includes = ["licenserc.toml"]
    EOS

    shell_output("#{bin}/hawkeye format", 1)
    assert File.read("licenserc.toml").start_with?("# Copyright © 1970")
  end
end
