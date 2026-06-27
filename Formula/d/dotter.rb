class Dotter < Formula
  desc "Dotfile manager and templater written in rust"
  homepage "https://github.com/SuperCuber/dotter"
  url "https://github.com/SuperCuber/dotter/archive/refs/tags/v0.13.4.tar.gz"
  sha256 "46135bcae1940cb22284308bd2cf75d78bb06a748136d835f29db978521fd45a"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36a6ed7c7532d987ee58325e854956607c4fc604de98e430f1e69cea774a3c02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74c671258a4621c806cf9ae2acd68aed779fc3f2871f8af5b7a8d91c41476504"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17167d23e44c100fc9f47e5c6c00eb49ec6ab31ef03df5a618f224f9371b4756"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8cf2736586332347c9dd11acb187963352aa43b14daccbd1287d700546aa153b"
    sha256 cellar: :any_skip_relocation, sonoma:        "97555d05db08fefdf290b69152bf1c7ccd408e0a49a409709836067688a32a99"
    sha256 cellar: :any_skip_relocation, ventura:       "a627706f9e7d8aa47cf4b23b0415313636599b912c3df693d82d3fe8b58d9c79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "518f20fa7c86be27c630e4be9d018176c0af69c43a9e228761ffb8bce53a8a98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38f63b924590be43e9dc62a39de04c621247bc23820fba6de6e63c32caa3cd56"
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
