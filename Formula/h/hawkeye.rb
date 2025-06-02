class Hawkeye < Formula
  desc "Simple license header checker and formatter, in multiple distribution forms"
  homepage "https://github.com/korandoru/hawkeye"
  url "https://github.com/korandoru/hawkeye/archive/refs/tags/v6.0.4.tar.gz"
  sha256 "0f0f2ac6d18ddbf7eaa04fcd39e293eb836354f0ba5de985f349bbf009fb8cf0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "348936758fb3cbccca49666bedbb8aa85c196bf01437d3d56cf481261176d089"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fe8f107f2087e1ec15f75bb1aaefa6cdcc52f661ef0b64d0404475044327fc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3bc876b7db337c91b8c3bc109da340e2be45c8084e187112fccad8b3bf9d729e"
    sha256 cellar: :any_skip_relocation, sonoma:        "52d725e571f6e82058e340cb5a8a7b9427f74d927d4d10ac5d34f28abfd5e981"
    sha256 cellar: :any_skip_relocation, ventura:       "54cbeb7a8e56034b3b22852c60bbb029abef5ee54292d836e8f8ba4ae4c1598b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b43df7f132a3a932a56a61108a1aecadbd846e971fa65aa4566b938ff3f6534d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b389df55ac7de112e8c31c55457676c17b4fd85d31871f04eb0e966055a1ecb2"
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
