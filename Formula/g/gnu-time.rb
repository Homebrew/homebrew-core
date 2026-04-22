class GnuTime < Formula
  desc "GNU implementation of time utility"
  homepage "https://www.gnu.org/software/time/"
  url "https://ftpmirror.gnu.org/gnu/time/time-1.10.tar.gz"
  mirror "https://ftp.gnu.org/gnu/time/time-1.10.tar.gz"
  sha256 "e8c29fb4ab599d8478e41e8618f50db8aede9c90af27d0d2ef28ae50d5de09c3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ae9f7fbf6e56886f0c126322f5a4ad47eb61d14b02d2b37fa51491ccd8cc7ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6d643fbbc1f1362553e5b23bf1faab2b9469a95194bd56eb3cec2e8c43cdab7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3b7ce7272013335803ac82b23ae9ac078b0085da7f593dd92f4ad1e00c62254"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5d6f1dd8e8a3f2582fae4eea0684558c56dd7d8146e60013ea6e37b83933a00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c9784f415917d7e4aa363ec7d0e89456e493c39a7e49113745a872b195029d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b675fc8cb2b3c659f05eee9aebdf2a7487c62934374f82198af666556d3c8d6e"
  end

  uses_from_macos "ruby" => :test

  def install
    args = %W[
      --prefix=#{prefix}
      --info=#{info}
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make", "install"

    (libexec/"gnubin").install_symlink bin/"gtime" => "time" if OS.mac?
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "time" has been installed as "gtime".
        If you need to use it as "time", you can add a "gnubin" directory
        to your PATH from your bashrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    if OS.mac?
      system bin/"gtime", "ruby", "--version"
      system opt_libexec/"gnubin/time", "ruby", "--version"
    else
      system bin/"time", "ruby", "--version"
    end
  end
end
