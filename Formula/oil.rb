class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.8.5.tar.gz"
  sha256 "4286eebb190f020e5c2472a48b0aa16a5abecfbf60068d1d9ad57d694e3ffc0a"
  license "Apache-2.0"
  head "https://github.com/oilshell/oil.git"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "42068d72ea52048dc6bde38406c5f95199533739001d969a526e30b32d15c264" => :big_sur
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
    script = 'path=$(pwd); echo -n "$path"'
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c '#{script}'")
    assert_match "name=val isn't allowed", shell_output("#{bin}/oil -c '#{script}' 2>&1", 2)
  end
end
