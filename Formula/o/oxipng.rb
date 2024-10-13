class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/refs/tags/v9.1.2.tar.gz"
  sha256 "8eae13e5aa6f500b231b4d15b9fefdeb5f6cc566ddab959b9b7a03a00bb3a520"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f0c10680850f68eda044e9fe0236096c940b1e63a04c8ff1f18b41aa5cc36d23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61fe715c46d6fc4acffb45eed889c0219adea85c35c38dbad5732e26ef99a709"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "871e6d10ee753261ee369a14a2b6c499b53c9ade1a96e64271bfcc3c583464ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "067c034d6f2d0415cea75c1be6f5bdf9f2de221669815fa300bf1e984fc4dbb3"
    sha256 cellar: :any_skip_relocation, sonoma:         "4448d918162773084745687b6ba364df4eb1a02eb23c3049b45724cbbbae0175"
    sha256 cellar: :any_skip_relocation, ventura:        "ff60fba1c599a027f16081878d380432861a7c230e0d602bef877de16ecadad6"
    sha256 cellar: :any_skip_relocation, monterey:       "8ae0d7da91b68309f0a22d5007e295228c41245b5df00a78ab7eced48725d847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f230c91e2efe7296160cf381f76700a8a9e02522ece97c32654923320fa662e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "target/release/assets/oxipng.1"
  end

  test do
    system bin/"oxipng", "--pretend", test_fixtures("test.png")
  end
end
