class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://openbabel.org"
  url "https://github.com/openbabel/openbabel/archive/openbabel-2-4-1.tar.gz"
  version "2.4.1"
  sha256 "594c7f8a83f3502381469d643f7b185882da1dd4bc2280c16502ef980af2a776"
  revision 1
  head "https://github.com/openbabel/openbabel.git"

  bottle do
    sha256 "4dfa1e352686274b2fb985bb6dbf2b5926565dc669266f9c85f0413fa72e3f07" => :mojave
    sha256 "2e830e6b8a7ae79015bb06e05b04935f6a63525cac28cca53dcb72f49334bc83" => :high_sierra
    sha256 "28bb84f75639741efbbf3a19ebffc1fc122d15fa74584440b84e265cdfd18db0" => :sierra
    sha256 "d2ca98556d58c6268b6be3f93cfc9a00a79559d081d7713ed14bc7882212b2ef" => :el_capitan
    sha256 "48724ff8b63ea446ea0f2095361ea93de0647eec2e220c8369b9910a11450213" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"

  def install
    args = std_cmake_args + %w[
      -DCAIRO_LIBRARY:FILEPATH=
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/obabel", "-:'C1=CC=CC=C1Br'", "-omol"
  end
end
