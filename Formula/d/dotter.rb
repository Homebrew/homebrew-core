class Dotter < Formula
  desc "Dotfile manager and templater written in rust"
  homepage "https://github.com/SuperCuber/dotter"
  url "https://github.com/SuperCuber/dotter/archive/refs/tags/v0.13.5.tar.gz"
  sha256 "4ce8550c53db13ddebd683828ee954bf71caed010b3337b291bc5a536aeddc18"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a45f8c1a341d497c4126516dda224b6e2b15818b562ac84ef6153c24b96c698"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e582e214c167ed2dc87ade2e6d2cb82629af397b71f6acec378cae2b7e486372"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "761bdc741243924ba7fa4899f9af12f25c0f2f58a8b59c883bd309ca36891d84"
    sha256 cellar: :any_skip_relocation, sonoma:        "faa1387f0a900b7e80f1994cf8a1d4202afc27b6489d9fd6eb9cd49b0589e9e8"
    sha256 cellar: :any,                 arm64_linux:   "f0992d1d5ca6d4f5d9a949b37e88c4bf5cd602883d3729abf1cec5fea32fc56e"
    sha256 cellar: :any,                 x86_64_linux:  "35f43c9c9de0378c57fbb86a10e83954a7fe8f1cba51436eeff66e204aca0a08"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"dotter", "gen-completions", "-s")
  end

  test do
    (testpath/"xxx.conf").write("12345678")
    (testpath/".dotter/local.toml").write <<~TOML
      packages = ["xxx"]
    TOML
    (testpath/".dotter/global.toml").write <<~TOML
      [xxx.files]
      "xxx.conf" = "yyy.conf"
    TOML

    system bin/"dotter", "deploy"
    assert_match "12345678", File.read("yyy.conf")
  end
end
