class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://github.com/nmstate/nmstate/releases/download/v2.2.56/nmstate-2.2.56.tar.gz"
  sha256 "ba453914dceb9e3e4e33f1079f5449dfc5c46e87a4aed8de0687a42af9f942f8"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33367d68fea99f0cfcd4d03224620fc5e14249b0694c3a4f98ac3f0e6da39c32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2df9b483bfb8d7fbe37b691f4da4bac1026bd61db9242ad91dace89493794994"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f54561cddc044651c2967336c3f2a8dc99d39c884c2cd6f666d5eff43f8b10e"
    sha256 cellar: :any_skip_relocation, sonoma:        "232a1d71669a1749b4625b94eb92c0a3ffc3160d8e1a7e15f339f22eea10ee21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d18f886ffccdd5fe31fc3f5895d3677abc1bdfef5ed8f1126a649ae71e0b827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a431d59e4bda5f7fed5b723d4c4d4afd5943f2cf9649b3dc1545a00d32f8d1f6"
  end

  depends_on "rust" => :build

  def install
    cd "rust" do
      args = if OS.mac?
        ["--no-default-features", "--features", "gen_conf"]
      else
        []
      end
      system "cargo", "install", *args, *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nmstatectl --version")

    assert_match "interfaces: []", pipe_output("#{bin}/nmstatectl format", "{}", 0)
  end
end
