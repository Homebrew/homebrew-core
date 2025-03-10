class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://github.com/nmstate/nmstate/releases/download/v2.2.42/nmstate-2.2.42.tar.gz"
  sha256 "ca1a1db4df29043cecadb705535c16ac3a19d484c5924b78f2ffd40694891390"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  depends_on "rust" => :build

  def install
    cd "rust/src/cli" do
      system "cargo", "install", "--no-default-features", "--features", "gen_conf", *std_cargo_args if OS.mac?
      system "cargo", "install", *std_cargo_args if OS.linux?
    end
  end

  test do
    system bin/"nmstatectl", "version"
  end
end
