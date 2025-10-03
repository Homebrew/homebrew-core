class Hawkeye < Formula
  desc "Simple license header checker and formatter, in multiple distribution forms"
  homepage "https://github.com/korandoru/hawkeye"
  url "https://github.com/korandoru/hawkeye/archive/refs/tags/v6.2.0.tar.gz"
  sha256 "09ff315b5d6df6ccae4a73c32f4a8762b34ed9733eede45b604ff4a77867b4af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d75d67c57d501affe30c1099a8380b0143747a1061e5f62633c588b89714659"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9239062f731a87a8d88c7020a54602654f0a0fc01817fc709d2e6b56fcd9cee3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cd89d03acb774c08ab0eb7be8730245962e4191b2f866dfb70c96710b8d7575"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "835360d95ae8d5a114a28c6217d59705107ec3b26f465ae5b5b1dfdb783a165b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ace5a271c81bc1ad23853eff46c1e06ebdc4fe34d117240fc889da845b7bf40"
    sha256 cellar: :any_skip_relocation, ventura:       "a4be7e66410e8a5a0abd1fb8a8289a0accd6b0086a3f3f5f877a0a2a893052eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaf5eb5c7870688f2e58f9fba8f881383d49e30db79151ae169839908ca6acf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f46462d1120a67c6263b826d4696d3db859d2944a807dab05bbaf290a998e85d"
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
