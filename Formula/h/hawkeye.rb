class Hawkeye < Formula
  desc "Simple license header checker and formatter, in multiple distribution forms"
  homepage "https://github.com/korandoru/hawkeye"
  url "https://github.com/korandoru/hawkeye/archive/refs/tags/v5.9.0.tar.gz"
  sha256 "e27496cdff53cbbee769fda96d351fa004548529ec81de175e6cbf10269dad3f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae351a2a02c07ad73abaec259b99b053b897dd6a6f0c9428e47ba032bca85636"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2a26498680c4002a807e6a882f9db0bc5e4ed948c0b0d6751193abecfff471d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e40d5a76799e186154c749a8b2da7fc6f7b366b9a383b83b3a7ddafb8da7c94"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e789ba9dbdfbc583674cc6d0ce06e948cc857d87855e28abac7f6f3c970e11e"
    sha256 cellar: :any_skip_relocation, ventura:       "a2ed1b70a5519e216fdd97954e4aea7971d3c0ac944f281c1bfa9864552f58c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30544b1c49437212b9249398d3f6d9a3d0a323a52482c489919c4c6a332d1eec"
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
