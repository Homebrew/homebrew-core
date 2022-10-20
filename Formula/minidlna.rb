class Minidlna < Formula
  desc "Media server software, compliant with DLNA/UPnP-AV clients"
  homepage "https://sourceforge.net/projects/minidlna/"
  url "https://downloads.sourceforge.net/project/minidlna/minidlna/1.3.0/minidlna-1.3.0.tar.gz"
  sha256 "47d9b06b4c48801a4c1112ec23d24782728b5495e95ec2195bbe5c81bc2d3c63"
  license "GPL-2.0-only"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d6e515b1672040010f55f8b0c10321c1d90ef3923201f724d37878b45eab7f8e"
    sha256 cellar: :any,                 arm64_big_sur:  "c501682a37f168c7fc6c69e97ff5ef327f95fe478e404199a83027c629a20622"
    sha256 cellar: :any,                 monterey:       "64a43285b054c1c20b54f02ea18396905d7c75ffec2d9085f8c4dd9ece0f2360"
    sha256 cellar: :any,                 big_sur:        "527a15ab85b5f20ab0d82d3b25109dcbbb5254c1245df114772dc7e56d4cf6dc"
    sha256 cellar: :any,                 catalina:       "31a0327514763858e81f17e6de6d63d0a4fcf531704e31d3a834cfc84ad6d6b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c083e8fa0d622dbcffb47617f1c4acc5a4dad8af098cbe047f680d5224f23d0b"
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
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libid3tag"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sqlite"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  def post_install
    conf = <<~EOS
      friendly_name=Mac DLNA Server
      media_dir=#{Dir.home}/.config/minidlna/media
      db_dir=#{Dir.home}/.config/minidlna/cache
      log_dir=#{Dir.home}/.config/minidlna
    EOS

    (pkgshare/"minidlna.conf").write conf unless File.exist? pkgshare/"minidlna.conf"
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
    run [opt_sbin/"minidlnad", "-d", "-f", "#{Dir.home}/.config/minidlna/minidlna.conf",
         "-P", "#{Dir.home}/.config/minidlna/minidlna.pid"]
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
