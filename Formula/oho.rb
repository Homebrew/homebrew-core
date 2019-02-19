class Oho < Formula
  desc "Takes your colorful terminal output and converts it to HTML for sharing"
  homepage "https://github.com/masukomi/oho"
  current_version="v1.3.2"
  url "https://github.com/masukomi/oho/releases/download/#{current_version}/oho_#{current_version}-source.tgz"
  sha256 "8ccd7d425d198adef47b2171c18d8ebd463e831ad23c7be654583118cac08751"

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"

  def install
    system "crystal", "build", "--release", "src/oho.cr"
    bin.install "oho"
  end

  test do
    out = pipe_output(bin/"oho", "[35mno[34mfascism[00m")
    style_regexp = %r{<span style="color: fuchsia; ">no<\/span><span style="color: #3333FF; ">fascism<\/span>}
    assert_match(style_regexp, out)
  end
end
