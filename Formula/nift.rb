class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.cc/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.0.1.tar.gz"
  sha256 "66aad5d280b7d7ea8a5ea5b6bee24a69883218df2bc455e7ffb60343b77d4e4a"

  bottle do
    cellar :any_skip_relocation
    sha256 "01710999e940f3da693e1039a0a541221346b6844ead58187ad25efa92f10764" => :catalina
    sha256 "44938b7a90af33c1e3da77774e94b20fdb99eab140fbd65138dab443c237bf72" => :mojave
    sha256 "34fcba14bc3de8dace551232b3d3e16fde9881d382b0fe167aacec79e12e39b9" => :high_sierra
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    mkdir "empty" do
      system "#{bin}/nsm", "init-html"
      assert_predicate testpath/"empty/site/index.html", :exist?
    end
  end
end
