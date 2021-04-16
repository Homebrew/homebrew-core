class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.dev/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.4.10.tar.gz"
  sha256 "3a7292d82471ed19ef6d723f40e4319ca9108275d49f13a583f61f21ff6dbb20"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "fb6510a7d3eef37e3274009abe1062585c07294c2453d563b70b9501fa70f719"
    sha256 cellar: :any_skip_relocation, catalina: "613a21f5107f0e099cd32b67779587807686faf7666366ce4cb1f218855a2d4f"
    sha256 cellar: :any_skip_relocation, mojave:   "62b96189d61ca0c360aa7c00718f0995fde9d20ad81c5a700836083800093aef"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    mkdir "empty" do
      system "#{bin}/nsm", "init", ".html"
      assert_predicate testpath/"empty/output/index.html", :exist?
    end
  end
end
