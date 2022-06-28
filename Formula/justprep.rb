class Justprep < Formula
  desc "Pre-processor to the 'just' command-line utility"
  homepage "https://github.com/MadBomber/justprep"
  url "https://github.com/MadBomber/justprep/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "0277839a9e7e3b821b2cf72efcb364a839a59dbbbaab0b1baa02594a4994f70c"
  license "MIT"

  depends_on "crystal" => :build
  depends_on "just" => [:build, :test]
  depends_on "bdw-gc"
  depends_on "libevent"
  depends_on "pcre"

  def install
    system "just", "crystal/build"
    bin.install "./crystal/bin/justprep"
  end

  test do
    (testpath/"include_me.just").write <<~EOS
      default:
        touch it-worked
    EOS

    (testpath/"main.just").write <<~EOS
      include ./include_me.just
    EOS

    system bin/"justprep"
    assert_predicate testpath/"justfile", :exist?

    system "just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
