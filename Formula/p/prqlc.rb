class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/PRQL/prql/archive/refs/tags/0.13.0.tar.gz"
  sha256 "2b2f64d5173800b1b82b1644e54b9c5e47e571d93faa1962371e52a47361dbb6"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db95988199f8725c3e250e5be68f88878c4cb6edd1a9351fa9ac73437ffa61f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a360776a25f4d0948e6067160dcc7b8473112f2f26e46157561d3ec667bf9e7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed734ba1ab2d3e45b4e00359c28e56b65d6887b11a3940518c11f623fc419406"
    sha256 cellar: :any_skip_relocation, sonoma:         "e17035c2073a6e614deee7a0ab06be7b7317e861ce627293f8a5eff4f325c764"
    sha256 cellar: :any_skip_relocation, ventura:        "bf9472bec7000798da3a6ec37af6cf0eced8bca712ff7d8e3eb930009d9be685"
    sha256 cellar: :any_skip_relocation, monterey:       "116e52b09cfed238301c852108664337844bdb9a7ed10765b839865ae43b9c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26a52696cd3b352832869e2552a45e9eb61c3f08fe0e35872358aadebaa161b3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prqlc/prqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end
