class CerealConsole < Formula
  desc "Terminal based serial console"
  homepage "https://github.com/ActuallyTaylor/cereal"
  url "https://github.com/ActuallyTaylor/cereal/archive/refs/tags/1.1.0.tar.gz"
  sha256 "3604d71d0f1d8e1965676ef16869bbf0860057e28f61afa5a20568f5c0af2aae"
  license "GPL-3.0-or-later"
  head "https://github.com/ActuallyTaylor/cereal.git", branch: "main"

  depends_on xcode: ["13.0", :build]

  depends_on macos: :big_sur

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release"
    bin.install ".build/release/cereal" => "cereal"
  end

  test do
    system bin/"cereal", "-h"
  end
end
