class Hawkeye < Formula
  desc "Simple license header checker and formatter, in multiple distribution forms"
  homepage "https://github.com/korandoru/hawkeye"
  url "https://github.com/korandoru/hawkeye/archive/refs/tags/v6.5.1.tar.gz"
  sha256 "ae7f7a5e16642c769c8fdb1f071e3677e01d7307b69ec745a242699c867f8a9e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e856c08894188d6726f27fe6233bd2b4ba756e647e8bf9859b021bde14264a55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47f533656f8746d714b19db9f392226653014f7db212c7e20027de857249b7b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8f3833c2a22ae3f3c91ff662c144b221805f51031cba46787cc58188886d5f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2cf98250f379d33bcb002cb105e0fbd1d6f2ce40bbf8e8834f11c6fcc009b82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da76de8a0df8a47154a77701d1d7204656a2ed4d6869bac9219086d392528c9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07f3953d9340e1d7c3dcd5d1f86b584824b9bafdd0cbe8fe282a0ddd425d7f92"
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
