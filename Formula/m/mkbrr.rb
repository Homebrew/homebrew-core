class Mkbrr < Formula
  desc "Is a tool to create, modify and inspect torrent files. Fast"
  homepage "https://mkbrr.com/introduction"
  url "https://github.com/autobrr/mkbrr/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "cbe565822332628566a30e58a940d7122a361f2344819f130d440accf07e88bd"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/mkbrr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c214a5343bd5bac2aba0f6757616b079ba29918a18f76c197c197147d71b63c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c214a5343bd5bac2aba0f6757616b079ba29918a18f76c197c197147d71b63c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c214a5343bd5bac2aba0f6757616b079ba29918a18f76c197c197147d71b63c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1f09c0d15c73b0c72d25d1d9695f7bcdb7bb2e758b0a281d29a7adb66c3d0d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b9635624a0dcce44ab751cc9e18ee606a3f515bad096ffb10343713bbc908a7"
    sha256 cellar: :any,                 x86_64_linux:  "3bb93dc7df95ecd05ab2b3e8d4a885a596dc3c6d1cbd0ceff0e666b632524e8e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.buildTime=#{time.iso8601}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mkbrr version")

    (testpath/"hello.txt").write "Hello, World!"
    system bin/"mkbrr", "create", (testpath/"hello.txt"), "-o", (testpath/"hello.torrent")

    assert_path_exists testpath/"hello.torrent", "Failed to create torrent file"
  end
end
