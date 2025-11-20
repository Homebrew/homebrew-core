class Hawkeye < Formula
  desc "Simple license header checker and formatter, in multiple distribution forms"
  homepage "https://github.com/korandoru/hawkeye"
  url "https://github.com/korandoru/hawkeye/archive/refs/tags/v6.3.0.tar.gz"
  sha256 "b83f1f9b3fc349e51ba1bb791d0b438de9aae4b4e10be865d14dce3a8fa70182"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3ab2aef2a64345717f82a6e177d66f3545cb379b8d84f67b36d400d0798c7ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "500c3e86d1fade2a902ec160d668ace68e0f029b5ffcc67e0730dcdb087d117c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df6eb2f9221caf586cd3507c0dcfd4cd2ec81e7828293562da0c7d91936f32dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "7600195b05d90df34c5a29cf4e43989380a6fe33f6ea428b3b0b9e89aed527ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3f68642869d38afd7e51d81c3cb72e9f99d8530c53c0a929ceac4c598d84a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d29a088e48ff2f798f38b79a773fb0504b70a58053acc7b45de6ca1df3873418"
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
