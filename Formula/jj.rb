class Jj < Formula
  desc "Jujutsu is a Git-compatible DVCS"
  homepage "https://github.com/martinvonz/jj"
  url "https://github.com/martinvonz/jj/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "f97832d69b4e486997b9548c41f6cc945c68b8a8b546172ca92b7eb23ec71be5"
  license "Apache-2.0"
  head "https://github.com/martinvonz/jj.git", branch: "main"

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
  end
  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"jj", "init", "--git"

    assert_predicate testpath/".jj", :exist?
  end
end
