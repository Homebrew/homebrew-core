class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://blog.kali-team.cn/projects/observer_ward/"
  url "https://github.com/emo-crab/observer_ward/archive/refs/tags/v2026.6.28.tar.gz"
  sha256 "36be8c3c6e6169eb5dfff450fe9d16372dac5a5a8b5d47a6c466555772bd7f74"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9825575a78113abeabf89a51985bf1bcfe20c792940efd3dd1bbd44a35a530c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e02a422bfd0ab15902bb0e08590c767f8219c927f2c5404befe10d6f44501b08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edb1ae3285315a6cf70a59bde39a7ed8cad4d3764cf72dcb1053d71ba3da91f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "512245263439b46fb241e130e59340d82c2d8ef119e64c81b68ed4fff0d8ea5e"
    sha256 cellar: :any,                 arm64_linux:   "5092d36a7d056ea3b7267e9ef56e33f1e202d6a2a9fbda72ebff340a4bc9f62c"
    sha256 cellar: :any,                 x86_64_linux:  "f7a31d6341359b76dfac2fc38e2f0fad5d2ca65c790af656614aec7044a31d27"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    rm ".cargo/config.toml" # disable `+crc-static`
    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  test do
    require "utils/linkage"

    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end
