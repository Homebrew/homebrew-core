class Pythia < Formula
  desc "Monte Carlo event generator"
  homepage "https://pythia.org"
  url "https://pythia.org/download/pythia83/pythia8317.tgz"
  version "8.317"
  sha256 "1ae551d14dac495ddfe6b344792035ebe410fe6c6004d44a335e0ece0e745adf"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pythia.org/releases"
    regex(/href=.*?pythia(\d)(\d{3})\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.join(".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  depends_on "rsync" => :build

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include "Pythia8/Pythia.h"

      int main() {
        Pythia8::Pythia pythia;
        return pythia.settings.mode("Beams:idA") == 2212 ? 0 : 1;
      }
    CPP

    flags = shell_output("#{bin}/pythia8-config --cxxflags --libs").split
    system ENV.cxx, "test.cc", "-o", "test", *flags
    system "./test"
  end
end
