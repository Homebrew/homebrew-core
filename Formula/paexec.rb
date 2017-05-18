class Paexec < Formula
  desc "Distributes tasks over network or CPUs"
  homepage "https://github.com/cheusov/paexec"
  url "https://downloads.sourceforge.net/project/paexec/paexec/paexec-1.0.1/paexec-1.0.1.tar.gz"
  sha256 "deed9dc7046bec584f32d9fda8ea8a44448528e3736742d98773fec6cfbb5898"

  depends_on "mk-configure" => :build
  depends_on "runawk"

  def install
    ENV["PREFIX"] = "#{prefix}"
    ENV["MANDIR"] = "#{man}"

    system "mkcmake", "all", "examples", "doc"
    system "mkcmake", "install", "install-examples", "install-doc"
    cp "presentation/paexec.pdf", "#{share}/doc/paexec/"
  end

  test do
    system "#{bin}/paexec", "-V"
  end
end
