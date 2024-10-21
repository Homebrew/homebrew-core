class Hawkeye < Formula
  desc "Simple license header checker and formatter, in multiple distribution forms"
  homepage "https://github.com/korandoru/hawkeye"
  url "https://github.com/korandoru/hawkeye/archive/refs/tags/v5.8.1.tar.gz"
  sha256 "bf8c002a3c5cd79d1e88bfa4ca326fb95f6d28be4d98cd4e0df098c35c0e2c72"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0e79b8da88e71f5fb819f25425c25f4752568fb2f3543928a400da0b3a9196a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e910e5e86e3a99633cac780524913a184fc5b4977759033efb48b5627442b716"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3da5fc6db177af7e01d9ed2a735310995e3d0c868da212a42b67accdd3311628"
    sha256 cellar: :any_skip_relocation, sonoma:        "54a86a6ff3ab3c23b0b8fd544c7a8c5a8980f50d346d82569c4468d7d6a0f572"
    sha256 cellar: :any_skip_relocation, ventura:       "2dd637dd89ee5c5ab64f42f9688c0445437d32553360dc71b1dcdf4cb9eb6125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be02712aa1188ca95911b8db17e3ab20903a2d29ec4c7b345056ebdf56cc27fa"
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
