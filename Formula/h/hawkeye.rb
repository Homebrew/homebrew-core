class Hawkeye < Formula
  desc "Simple license header checker and formatter, in multiple distribution forms"
  homepage "https://github.com/korandoru/hawkeye"
  url "https://github.com/korandoru/hawkeye/archive/refs/tags/v6.0.2.tar.gz"
  sha256 "5b9bd03c537ca2c21f2fb43885a75d1f38485595891013d64acc1f41ac6b0b1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b31be72aa22c1c8f363a1007183cb85cde69c59f87f27d396474e5da1594b809"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e77ba6abbc599f988f11badb64812d43bd73dddf486bc6f0af8684e0895de1f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2d52bcdb06b224c6337382a84f9e754e1a0de1054841302f0591137d031e48c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ff85d3bdb94ab9b03ee00051ae35bd23c4536204d07dc145bfbf77d209e5a28"
    sha256 cellar: :any_skip_relocation, ventura:       "fcadd91c492561888846fef4f48302e6b8073b9504897fce2ab37a9c6c11a35d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "480c684fa2cbd99c1d89341c1f0cea5eba229c67a53828f7e546eb40557c2d15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec3e86c0f928966cf8cf0aee37fb1bcac3c84ea2af942e95fbe3580cbcb66772"
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
