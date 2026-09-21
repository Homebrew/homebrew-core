class Hawkeye < Formula
  desc "Simple license header checker and formatter, in multiple distribution forms"
  homepage "https://github.com/korandoru/hawkeye"
  url "https://github.com/korandoru/hawkeye/archive/refs/tags/v7.2.0.tar.gz"
  sha256 "d85bc32c3813040a83c72555998f74ca1e7218b6908faf1106d29af279e61e51"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "64d411b53ff9dbea47a4418d2792900a9c8ce9ebecd40f81013f9af6f4f96bec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f35049b19fca8f4c05e5d54c19a8ac5dd8608eb2de8e110182f57aae1d59c553"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3ac027aab9d5f62cdecd6f2ff20e000209510b19fade04cc6e74b9522feb008"
    sha256 cellar: :any,                 arm64_linux:       "27dc778ccf0baf028e214065c1231a363daf79bc7c58d7e06fa9df1b76ca3c6a"
    sha256 cellar: :any,                 x86_64_linux:      "492ae481e8f6ef412702b91030778f5cafd90dea8116a90aafe5e47a473eb799"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "hawkeye")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hawkeye --version")

    configfile = testpath/"licenserc.toml"
    configfile.write <<~TOML
      includes = ["licenserc.toml"]
    TOML

    assert_match "unknown field `includes`", shell_output("#{bin}/hawkeye format 2>&1", 2)
  end
end
