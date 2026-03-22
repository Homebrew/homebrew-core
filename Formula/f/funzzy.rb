class Funzzy < Formula
  desc "Lightweight file watcher"
  homepage "https://github.com/cristianoliveira/funzzy"
  url "https://github.com/cristianoliveira/funzzy/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "9c98ff08a611a8c3fc9eedd5bc56ecdc9fbd7ec5630d020cd1aa7426524df3d3"
  license "MIT"
  head "https://github.com/cristianoliveira/funzzy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caa2f8d37826f07fe6bbe6e6c2b63632f8a47a15a6c5618bc2af0b30c1b691a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ceea0be6258bfe342bef5003d2ba506115caa6d195ca77f2eb27cb34fd51732"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f14ac7984d837a4ed4410ad1dd8fe90016499c4f49aca53b89d132bccdc8971"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a6d6a725210b6958a424d61929e5e4549f71e6696711df42161d40103429a44"
    sha256 cellar: :any_skip_relocation, sonoma:        "44fd7535e861bd71c7b718a3fcd1da9635a673293afd66efea8ed0801429ab9e"
    sha256 cellar: :any_skip_relocation, ventura:       "bb81d3d605a3ede84e89243353840ba51cfd3c834c4c7a062343c84d61ee3a12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4227fc7942e32ad7abf6330e78b82942adfa7bf2fa7a802a37d72e50200f9767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cea877d0499d698f84ab37af2e7e92643fc8a61cca0ae29af045efaf45e0810"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"funzzy", "init"
    assert_match "## Funzzy events file", File.read(testpath/".watch.yaml")

    assert_match version.to_s, shell_output("#{bin}/funzzy --version")
  end
end
