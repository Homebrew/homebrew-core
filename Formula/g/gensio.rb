class Gensio < Formula
  desc "Stream I/O Library"
  homepage "https://github.com/cminyard/gensio"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/gensio-2.8.4.tar.gz"
  sha256 "1517af8e9ba587fd26c5f87a7f9f28c583e63a15e0892f855239143009f6fa58"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]

  depends_on "go" => [:build]
  depends_on "pkg-config" => [:build]
  depends_on "swig" => [:build]
  depends_on "glib"
  depends_on "openssl@3"
  depends_on "portaudio"
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    # https://rubydoc.brew.sh/Formula.html#std_configure_args-instance_method
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-pythoninstall=#{lib}/gensio-python",
                          "--sysconfdir=#{etc}"
    system "make", "install"
    (prefix/Language::Python.site_packages(python3)).install_symlink Dir["#{lib}/gensio-python/*"]
  end

  service do
    run [opt_sbin/"gtlsshd", "--nodaemon", "--pam-service", "sshd"]
    keep_alive true
    require_root true
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gensiot --version")

    assert_equal "Hello World!", pipe_output("#{bin}/gensiot echo", "Hello World!")
  end
end
