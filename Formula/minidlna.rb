class Minidlna < Formula
  desc "Media server software, compliant with DLNA/UPnP-AV clients"
  homepage "https://sourceforge.net/projects/minidlna/"
  url "https://downloads.sourceforge.net/project/minidlna/minidlna/1.3.0/minidlna-1.3.0.tar.gz"
  sha256 "47d9b06b4c48801a4c1112ec23d24782728b5495e95ec2195bbe5c81bc2d3c63"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "aa5d1420c5a2b0e89ac9e1dba2dc076b80b97fd90535367837fcbbc9c26d7c68"
    sha256 cellar: :any,                 arm64_big_sur:  "3296fc2759c028ff9316c712504be6644eb5e1fb15155e2aea1f8c4bb609cc33"
    sha256 cellar: :any,                 monterey:       "dedb1a51edc778969549199ed98fb2a5f4a4ec7cc4bb8e758d3f2afbc239f01d"
    sha256 cellar: :any,                 big_sur:        "92e3ced10e41d5528a06befe8124b0badde96b3542c094109c0d9b07315af0c4"
    sha256 cellar: :any,                 catalina:       "e43528eb7559099f5dd38d278c75ac2555be3f28474c84a7005e5a16f920e528"
    sha256 cellar: :any,                 mojave:         "fc24ceaaed86d9b4417349afa20ad6c86b765097314cc01bb2bb81d83a4c4639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "384178070afc9696895c67b06ae128b82bc094be413fbb8e148aa30afdb58272"
  end

  head do
    url "https://git.code.sf.net/p/minidlna/git.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "jpeg"
  depends_on "libexif"
  depends_on "libid3tag"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sqlite"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    (pkgshare/"minidlna.conf").write <<~EOS
      friendly_name=Mac DLNA Server
      media_dir=#{ENV["HOME"]}/.config/minidlna/media
      db_dir=#{ENV["HOME"]}/.config/minidlna/cache
      log_dir=#{ENV["HOME"]}/.config/minidlna
    EOS
  end

  def caveats
    <<~EOS
      Simple single-user configuration:

      mkdir -p ~/.config/minidlna
      cp #{opt_pkgshare}/minidlna.conf ~/.config/minidlna/minidlna.conf
      ln -s YOUR_MEDIA_DIR ~/.config/minidlna/media
      minidlnad -f ~/.config/minidlna/minidlna.conf -P ~/.config/minidlna/minidlna.pid
    EOS
  end

  service do
    run [opt_sbin/"minidlnad", "-d", "-f", "#{ENV["HOME"]}/.config/minidlna/minidlna.conf",
         "-P", "#{ENV["HOME"]}/.config/minidlna/minidlna.pid"]
    keep_alive true
    log_path var/"log/minidlnad.log"
    error_log_path var/"log/minidlnad.log"
  end

  test do
    require "expect"

    (testpath/".config/minidlna/media").mkpath
    (testpath/".config/minidlna/cache").mkpath
    (testpath/"minidlna.conf").write <<~EOS
      friendly_name=Mac DLNA Server
      media_dir=#{testpath}/.config/minidlna/media
      db_dir=#{testpath}/.config/minidlna/cache
      log_dir=#{testpath}/.config/minidlna
    EOS

    port = free_port

    io = IO.popen("#{sbin}/minidlnad -d -f minidlna.conf -p #{port} -P #{testpath}/minidlna.pid", "r")
    io.expect("debug: Initial file scan completed", 30)
    assert_predicate testpath/"minidlna.pid", :exist?

    assert_match "MiniDLNA #{version}", shell_output("curl localhost:#{port}")
  end
end
