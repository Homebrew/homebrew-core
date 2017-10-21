require "language/go"

class Megacmd < Formula
  desc "Command-line client for mega.co.nz storage service"
  homepage "https://github.com/t3rm1n4l/megacmd"
  url "https://github.com/t3rm1n4l/megacmd/archive/0.013.tar.gz"
  sha256 "f76e14678f2da8547545c2702406e27983e0a72263ef629b3ee4db226b94f6ae"
  head "https://github.com/t3rm1n4l/megacmd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "12ce5caa7064f8bb5ede1e1663794fa73b6622ec7d6c4b01124a6ff14330a6bf" => :high_sierra
    sha256 "ae598a728f664da115a979123e2a0d1ba05fd0b96766f63c65c5dd1f210baace" => :sierra
    sha256 "c100c1ca95dbe63a3cf23353517163328b2178fff1bbe4bdfc947c1ba0776884" => :el_capitan
  end

  depends_on "go" => :build

  go_resource "github.com/t3rm1n4l/go-humanize" do
    url "https://github.com/t3rm1n4l/go-humanize.git",
        :revision => "e7ed15be05eb554fbaa83ac9b335556d6390fb9f"
  end

  go_resource "github.com/t3rm1n4l/go-mega" do
    url "https://github.com/t3rm1n4l/go-mega.git",
        :revision => "551abb8f1c87053be3f24282d198a6614c0ca14f"
  end

  go_resource "github.com/t3rm1n4l/megacmd" do
    url "https://github.com/t3rm1n4l/megacmd.git",
        :revision => "d7f3f3a2427cc52b71cad90b26889e2a33fc3565"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"megacmd"
  end

  test do
    system bin/"megacmd", "--version"
  end
end
