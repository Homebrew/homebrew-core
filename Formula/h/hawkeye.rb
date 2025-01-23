class Hawkeye < Formula
  desc "Simple license header checker and formatter, in multiple distribution forms"
  homepage "https://github.com/korandoru/hawkeye"
  url "https://github.com/korandoru/hawkeye/archive/refs/tags/v5.9.1.tar.gz"
  sha256 "31e4f8ff957d912d792616593a84f348b53114480d15956f644ee2cba9795ce0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71184dab1a8e4031661b7e9c173359d22376609c7196a57832ecf909f7991d8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "901b915e4b86787ecebfe55204d0187a2f55e5b9382cee539ac15db02c40de68"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6cd1708df627e140946cd5303328e0ef2d67810fbcaf143a6168ca71bc74176a"
    sha256 cellar: :any_skip_relocation, sonoma:        "209dd15b7949d78ab6c10a2d80584079d104f81e81f53f04d5caa4d30493d058"
    sha256 cellar: :any_skip_relocation, ventura:       "e92872cee42e5c0f7b4ac7e9f4e2f5434084d9cdfe8a6ab748532e2e2bd2cc01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "413b9fdd949168526f429299b587ae4956df0f37dea83e8b44f1afabc8115a8d"
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
