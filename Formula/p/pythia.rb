class Pythia < Formula
  desc "Monte Carlo event generator"
  homepage "https://pythia.org"
  url "https://pythia8.web.cern.ch/releases/pythia83/pythia8318.tgz"
  version "8.318"
  sha256 "85dce1e623f91499b2973e3f939bf760b0f745ad4f4eb1bd0fbce2074e2e8f5c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pythia.org/releases"
    regex(/href=.*?pythia(\d)(\d{3})\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.join(".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_golden_gate: "e4445e451928da92135dbbb8800d527a58bd53bc3be424c765112022a9bf0423"
    sha256 arm64_tahoe:       "e5160ba954d21bc69f470619a00ec7c0a77ad6126f97a2af5d0bc428939d1d74"
    sha256 arm64_sequoia:     "85871e9517a839d3a516fdb7377766f6ea7e04c8dfe63c15bb3a900526c2ffa7"
    sha256 arm64_linux:       "d4753068ceeb3e21384c19ff6476bccecd6fbabf71781f49a71dde1a7b7567e0"
    sha256 x86_64_linux:      "4d91d0cc9709076766e193f8fe5e6fbdca1005f46fe9a2427ae38154cd6fe6c1"
  end

  uses_from_macos "rsync" => :build

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
