class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://static.crates.io/crates/nmstatectl/nmstatectl-2.2.63.crate"
  sha256 "86ba1ec1ea4059c75dc27dd4284a0e83e0b1311c0949668ab58ef9781f521e66"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  bottle do
    manifest_sha256 "dea11c31bdac58fd3f7cb770ae30ba14cafbdfde7211fa6ec1ab4fa08b8adbe1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "610ae0ef5624766a8bff603e5961105413472fe983a6a5c407650f5b73dcddb5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e65a8b1ebb23c2c12b4704fd6269c28a66f484c4694676d43f3f877388a6ce6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7425522460fe852ac3896f662ed353cfffb7f2c094252ecf93c762ac767a2760"
    sha256 cellar: :any,                 arm64_linux:       "32dbd1de1b69c658fb2bcaa9a7fd9c8e6d6e808bacca382d0f9e758b7dbc20ae"
    sha256 cellar: :any,                 x86_64_linux:      "cf827e49240aa0c0e0d1c6c87600d65cb6e60d5c11fab885b5077e609293db94"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    cd(build.head? ? "rust" : ".") do
      system "cargo", "generate-lockfile" if build.head?
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    cd(build.head? ? "rust" : ".") do
      if OS.mac?
        args = ["--no-default-features"]
        features = ["gen_conf"]
      end
      system "cargo", "install", *args, *std_cargo_args(path: build.head? ? "src/cli" : ".", features:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nmstatectl --version")

    assert_match "interfaces: []", pipe_output("#{bin}/nmstatectl format", "{}", 0)
  end
end
