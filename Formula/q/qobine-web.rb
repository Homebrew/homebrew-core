class QobineWeb < Formula
  desc "Server and web based player for Qobuz"
  homepage "https://github.com/SofusA/qobine"
  url "https://github.com/sofusA/qobine/archive/refs/tags/v2026-07-21.tar.gz"
  sha256 "8beda8cf9a78ef02f97f8ed2c3649cdc04bc551dc2d8db5552f9bba89c52fe7e"
  license "GPL-3.0-only"
  head "https://github.com/sofusa/qobine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dae12f917ba3c5a7ae5db4ab8fc4ed367cc2a7528c6bff59bf84ed20cf043454"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0c461b15a0e885175b280da55788ae0de6a5e85eebb336f5b5f9db7b5a4882b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd965cd5890c4540c9d283efd2019bc8a1db52333d82aa83a7cf30cbd23e3b86"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8145844fcc75594590498dd94807c4706aee18305732f689a0af9b5b0357c8e"
    sha256 cellar: :any,                 arm64_linux:   "2220732dace4c17f1f4df1fb93514347af6069661dc0ca43e6609b8e1f4134c1"
    sha256 cellar: :any,                 x86_64_linux:  "645aca84f1a499182419cee0c351d3285efef8b8aefa2c8a328baa928b19d408"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "web-module")
  end

  test do
    _, stdout, = Open3.popen2("#{bin}/qobine-web login")
    assert_match "Login to Qobuz in browser...", stdout.gets("\n")
  end
end
