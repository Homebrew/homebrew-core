class Hawkeye < Formula
  desc "Simple license header checker and formatter, in multiple distribution forms"
  homepage "https://github.com/korandoru/hawkeye"
  url "https://github.com/korandoru/hawkeye/archive/refs/tags/v6.1.1.tar.gz"
  sha256 "9a3f4b4d44bbbc887c3aeaeb4da9a43ae3eeee96699c6afc79e21d2636833739"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "757c352657231d51e0177489d4d618704fe6b9eaf85724b1feaf6dddf0ec5168"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59fb0e24b4f2a9eaacbc4ebf7dcdfa1fdf336e5edc1e688ceb9b89ae80809fff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d55af7c0bead3da1886a5755e7b7508fa891babfc198e2ea3a8e45936ef9aa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7ad583590a14120331136eac157efc9401c3ed2a1d72c880b8b0165fcae6b68"
    sha256 cellar: :any_skip_relocation, ventura:       "a65c7d355e270ca3aad85ca8f1d23d949eb3e1d5f74777dbab1e26ef3881022f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb66158c804fcab5cfe42d939358abf66fa2fdcc8a9252456e75f1cb95065413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcbbbc3ff7c07e3a85a22c0176c468dbd3795272de6f5173303446573e225794"
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
