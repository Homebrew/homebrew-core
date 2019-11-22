class Gist < Formula
  desc "Command-line utility for uploading Gists"
  homepage "https://github.com/defunkt/gist"
  url "https://github.com/defunkt/gist/archive/v5.0.0.tar.gz"
  sha256 "28a3ebaad90ede9a59bd4dbe4850a07cc6e3294a92849a0f0b17ebf6a17ea33b"
  head "https://github.com/defunkt/gist.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2a23dfb483d7647bd8cb99e617e6d667ba5bb7729769a83c09165dfd3cd6850" => :catalina
    sha256 "75bf2e9361e632351f86b2a0b8a4d2b3bd23eca6c3d6cde254b010e142fb7336" => :mojave
    sha256 "12b05e5b399458d2d89e91a41d7af8c5f2d6578ecfa4ab941eb5edb103c7448a" => :high_sierra
    sha256 "7e9a21eaf63bb8063b3ffdc9b7ee93cfb061c8f96df41670325eca555936809d" => :sierra
    sha256 "7e9a21eaf63bb8063b3ffdc9b7ee93cfb061c8f96df41670325eca555936809d" => :el_capitan
  end

  depends_on "ruby" if MacOS.version <= :sierra

  def install
    system "rake", "install", "prefix=#{prefix}"
  end

  test do
    output = pipe_output("#{bin}/gist", "homebrew")
    assert_match "Github now requires credentials", output
  end
end
