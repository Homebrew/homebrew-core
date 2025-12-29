class Libsystemd < Formula
  include Language::Python::Virtualenv

  desc "Port of systemd libsystemd components to macOS"
  homepage "https://github.com/open-sources-port/systemd-port"
  url "https://github.com/open-sources-port/systemd-port/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "be469667d6fa1a7f6ea48034b3eeedd4fa877d3aed8146dde8fa9dc3978d1fcd"
  license "LGPL-2.1-or-later"

  depends_on :macos

  depends_on "coreutils"
  depends_on "libgcrypt"
  depends_on "libxcrypt"
  depends_on "ccrypt"
  depends_on "gettext"
  depends_on "util-linux" # provides libmount
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "jinja2-cli" => :build

  # resource "jinja2" do
  #   url "https://files.pythonhosted.org/packages/source/J/Jinja2/Jinja2-3.2.3.tar.gz"
  #   sha256 "a2f7f0446a11b60d2f7f650de4f848b04e7f6dc575826c437a2a9274b621e2e4"
  # end

  # resource "jinja2-cli" do
  #   url "https://files.pythonhosted.org/packages/source/j/jinja2-cli/jinja2-cli-1.1.1.tar.gz"
  #   sha256 "f1d8630e9bfbf8f1f16209db5c728ccf781e1c5d0dc8ef1ff1b13f306be5d9e8"
  # end

  def install
    # Use Homebrew compiler toolchain
    ENV["CC"]  = ENV.cc
    ENV["CXX"] = ENV.cxx

    # Create Python virtualenv for build dependencies
    venv = virtualenv_create(buildpath/"venv", "python3")
    venv.pip_install "jinja2"
    venv.pip_install "jinja2-cli[env]"

    # Make sure Meson finds the virtualenv python
    ENV.prepend_path "PATH", buildpath/"venv/bin"

    # Provide GNU realpath without global symlinks
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin"

    cd "macos-homebrew" do
      system "CC=clang", "CXX=clang++", "meson", "setup", "build",
             "--buildtype=debugoptimized",
             "--prefix=#{prefix}",
             "--sysconfdir=#{etc}",
             "--localstatedir=#{var}"
            #  "-Ddefault-hierarchy=unified",
            #  "-Dselinux=false",
            #  "-Dapparmor=false",
            #  "-Dima=false",
            #  "-Dsmack=false",
            #  "-Dpolkit=false",
            #  "-Dresolve=false",
            #  "-Dtimesyncd=false",
            #  "-Dmachined=false",
            #  "-Dlogind=false",
            #  "-Dnetworkd=false",
            #  "-Dhomed=false",
            #  "-Dfirstboot=false",
            #  "-Dldconfig=false"

      system "meson", "compile", "-C", "build"
      system "meson", "install", "-C", "build"
    end
  end

  test do
    system "pkg-config", "--exists", "libsystemd"

    (testpath/"test.c").write <<~EOS
      #include <systemd/sd-daemon.h>
      int main() { return sd_booted(); }
    EOS

    system ENV.cc, "test.c",
      "-I#{include}",
      "-L#{lib}", "-lsystemd",
      "-o", "test"

    system "./test"
  end
end
