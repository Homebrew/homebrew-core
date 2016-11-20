class Natalie < Formula
  desc "Storyboard Code Generator (for Swift)"
  homepage "https://github.com/krzyzanowskim/Natalie"
  url "https://github.com/krzyzanowskim/Natalie/archive/0.5.0.tar.gz"
  sha256 "66e00a4095121255a9740a16a8a59daa289f878f2e1e77ba6a9f98d6a671a33c"
  head "https://github.com/krzyzanowskim/Natalie.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b6b0597c2bd6e6b1c5df362d846da233f91727f62914f703503dd8360ddea53e" => :sierra
    sha256 "472b56132024812e48041b4ea4174e889f95eab70e8ff83d6182bde406865d88" => :el_capitan
  end

  depends_on :xcode => ["8.0", :build]

  def install
    ENV["CC"] = which(ENV.cc)
    system "swift", "build", "-c", "release", "-Xswiftc", "-static-stdlib"
    bin.install ".build/release/natalie"
    share.install "NatalieExample"
  end

  test do
    generated_code = Utils.popen_read("#{bin}/natalie #{share}/NatalieExample")
    assert generated_code.lines.count > 1, "Natalie failed to generate code!"
  end
end
