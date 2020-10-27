class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.8.3.tar.gz"
  sha256 "463efc219af8e77eb0b0d183feaa357f4d8e7c3813382055ef262c91a0c44092"
  license "Apache-2.0"
  head "https://github.com/oilshell/oil.git"

  bottle do
    sha256 "b184f8496f001e47b9dbf2822cf69476c74af91042d1fffe855fd347ca24fb80" => :catalina
    sha256 "80bc6f37ee51eec363ac13c69c3910aef46d594a9d16a1de1b14645c3437ef10" => :mojave
    sha256 "43d4aa89e3a88da11799780d154bb629bb051b52c3e251e2f47faf623f02e28a" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "./install"
  end

  test do
    assert_equal pipe_output("#{bin}/osh -c 'pwd'").strip, testpath.to_s
  end
end
